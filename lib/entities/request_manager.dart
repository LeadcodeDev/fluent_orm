import 'dart:async';

import 'package:fluent_orm/entities/model.dart';
import 'package:fluent_orm/entities/model_wrapper.dart';
import 'package:fluent_orm/fluent_manager.dart';
import 'package:fluent_orm/query_builder/clause.dart';
import 'package:fluent_orm/query_builder/declarations/declare_metadata.dart';
import 'package:fluent_orm/query_builder/declarations/declare_property.dart';
import 'package:fluent_orm/query_builder/declarations/declare_relation.dart';
import 'package:fluent_orm/query_builder/preloaded_relation.dart';
import 'package:fluent_orm/query_builder/punctuations/end_punctuation.dart';
import 'package:fluent_orm/query_builder/query_structure.dart';
import 'package:postgres/postgres.dart';

class RequestManager {
  final FluentManager _manager;

  RequestManager(this._manager);

  Future<T> commit<T, M> ({ List<PreloadRelation> preloads = const [], required String query, bool selectOne = false }) async {
    final result = await _manager.client.execute(query);

    if (T == List<M>) {
      return listOf<M>(result, preloads) as dynamic;
    }

    if (T == M) {
      return elementOf<M>(result.first, preloads, selectOne: selectOne) as dynamic;
    }

    return result as T;
  }

  Future commitModel<M> ({ List<PreloadRelation> preloads = const [], required String query, bool selectOne = false }) async {
    final result = await _manager.client.execute(query);
    return elementOf<M>(result.first, preloads, selectOne: selectOne) as dynamic;
  }

  Future<List<Map>> commitPivot (String query) async {
    final result = await _manager.client.execute(query);

    return result.map((row) =>
      row.columnDescriptions.fold({}, (acc, element) => {
        ...acc,
        element.columnName: row[row.columnDescriptions.indexOf(element)]
      })
    ).toList();
  }

  Future<T> elementOf<T> (PostgreSQLResultRow result, List<PreloadRelation> preloads, { bool selectOne = false }) async {
    final ModelWrapper model = _manager.resolve<T>();
    final Model instance = model.constructor();
    dynamic id;

    if (instance.metadata is DeclareMetadata) {
      (instance.metadata as DeclareMetadata).bucket
        ..putIfAbsent('modelName', () => model.modelName)
        ..putIfAbsent('tableName', () => model.modelName);
    }


    for (final column in result.columnDescriptions) {
      final index = result.columnDescriptions.indexOf(column);
      (instance.properties as DeclareProperty).bucket.putIfAbsent(column.columnName, () => result[index]);

      if (column.columnName == 'id') {
        id = result[index];
      }
    }

    if (preloads.isNotEmpty) {
      for (final preload in preloads) {
        final e = await preload.query(id);

        final relations = instance.relations as DeclareRelation;
        relations.bucket.putIfAbsent(
          '${preload.type}::${preload.relation.tableName}',
          () => selectOne ? e[0] : e
        );
      }
    }

    instance.manager = _manager;
    return Future.value(instance as FutureOr<T>?);
  }

  Future<List<T>> listOf<T> (PostgreSQLResult result, List<PreloadRelation> preloads) async {
    final List<T> arr = [];
    for (final row in result) {
      arr.add(await elementOf<T>(row, preloads));
    }

    return arr;
  }

  Future<T> commitWithoutModel<T> ({ required String query, bool first = false }) async {
    final result = await _manager.client.execute(query);

    final data = result.map((row) =>
      row.columnDescriptions.fold({}, (acc, element) => {
        ...acc,
        element.columnName: row[row.columnDescriptions.indexOf(element)]
      })
    ).toList();

    return switch (first) {
      true => data.firstOrNull,
      _ => data
    } as T;
  }

  String buildQuery(QueryStructure structure) {
    final List<Clause> instructions = [];

    if (structure.clauses.select != null) {
      instructions.add(structure.clauses.select!);
    }

    if (structure.clauses.from != null) {
      instructions.add(structure.clauses.from!);
    }

    if (structure.clauses.where.isNotEmpty) {
      instructions.addAll(structure.clauses.where);
    }

    if (structure.clauses.limit != null) {
      instructions.add(structure.clauses.limit!);
    }

    return instructions.map((e) => e.query).join(' ');
  }
}