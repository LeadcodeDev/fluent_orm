import 'dart:async';

import 'package:fluent_orm/entities/model.dart';
import 'package:fluent_orm/entities/model_wrapper.dart';
import 'package:fluent_orm/fluent_manager.dart';
import 'package:fluent_orm/query_builder/declarations/declare_metadata.dart';
import 'package:fluent_orm/query_builder/declarations/declare_property.dart';
import 'package:fluent_orm/query_builder/declarations/declare_relation.dart';
import 'package:fluent_orm/query_builder/preloaded_relation.dart';
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

        if (instance.relations is DeclareRelation) {
          (instance.relations as DeclareRelation).bucket.putIfAbsent(
            '${preload.type}::${preload.relation.tableName}',
            () => selectOne ? e[0] : e
          );
        }
      }
    }

    return Future.value(instance as FutureOr<T>?);
  }

  Future<List<T>> listOf<T> (PostgreSQLResult result, List<PreloadRelation> preloads) async {
    final List<T> arr = [];
    for (final row in result) {
      arr.add(await elementOf<T>(row, preloads));
    }

    return arr;
  }

  Future<List<dynamic>> commitWithoutModel ({ required String query }) async {
    final result = await _manager.client.execute(query);

    return result.map((row) =>
      row.columnDescriptions.fold({}, (acc, element) => {
        ...acc,
        element.columnName: row[row.columnDescriptions.indexOf(element)]
      })
    ).toList();
  }
}