import 'dart:async';

import 'package:fluent_orm/clients/psql/query_builder/psql_clause_structure.dart';
import 'package:fluent_orm/fluent_manager.dart';
import 'package:fluent_orm/clients/common/clause.dart';
import 'package:fluent_orm/clients/common/declarations/declare_metadata.dart';
import 'package:fluent_orm/clients/common/model.dart';
import 'package:fluent_orm/clients/common/model_wrapper.dart';
import 'package:fluent_orm/clients/common/preloaded_relation.dart';
import 'package:fluent_orm/clients/common/query_structure.dart';
import 'package:postgres/postgres.dart';

class RequestManager {
  final FluentManager _manager;

  RequestManager(this._manager);

  Future<T?> commit<T> (String query) async {
    final result = await _manager.provider.execute(query);

    if (T == List) {
      return result.isEmpty
        ? [] as T
        : _listElementOf<T>(result);
    }

    return result.isNotEmpty
      ? _elementOf<T>(result.first) as T
      : null;
  }

  T _listElementOf<T> (PostgreSQLResult rows) {
    final List arr = [];
    for (final row in rows) {
      arr.add(_elementOf<T>(row));
    }

    return arr as T;
  }

  Map<String, dynamic> _elementOf<T> (PostgreSQLResultRow row) {
    final Map<String, dynamic> bucket = {};

    for (final column in row.columnDescriptions) {
      final index = row.columnDescriptions.indexOf(column);
      bucket.putIfAbsent(column.columnName, () => row[index]);
    }

    return bucket;
  }

  T assignToModel<T> (Map<String, dynamic> payload) {
    final modelWrapper = _manager.resolve<T>();
    final instance = modelWrapper.constructor();
    final internalModel = instance.model as InternalModel;

    internalModel
      ..manager = _manager
      ..bucket.addAll(payload)
      ..metadata = DeclareMetadata({
        'modelName': modelWrapper.modelName,
        'tableName': modelWrapper.tableName
      });

    return instance;
  }

  Future<void> applyPreloads<T> (T instance, List<PreloadRelation> preloads) async {
    if (instance is Model) {
      final internalModel = instance.model as InternalModel;

      for (final preload in preloads) {
        final ModelWrapper modelWrapper = _manager.resolveFromType(preload.modelType);
        final relatedResult = await preload.query(instance.model.property('id'));

        internalModel.relations.bucket.putIfAbsent(
          '${preload.relationType}::${modelWrapper.tableName}',
          () => relatedResult
        );
      }
    }
  }

  String buildSelectQuery (QueryStructure<PsqlClauseStructure> structure) {
    final List<Clause?> instructions = [
      structure.clauses.select,
      structure.clauses.from,
      ...structure.clauses.where,
      structure.clauses.limit,
      ...structure.clauses.order
    ];

    return instructions.nonNulls
      .map((element) => element.query)
      .join(' ');
  }

  String buildInsertQuery (QueryStructure<PsqlClauseStructure> structure) {
    final List<Clause?> instructions = [
      structure.clauses.insert,
      structure.clauses.into,
      structure.clauses.values,
      structure.clauses.returning,
    ];

    return instructions.nonNulls
      .map((element) => element.query)
      .join(' ');
  }

  String buildUpdateQuery (QueryStructure<PsqlClauseStructure> structure) {
    final List<Clause?> instructions = [
      structure.clauses.update,
      structure.clauses.table,
      structure.clauses.set,
      ...structure.clauses.where,
      structure.clauses.returning,
    ];

    return instructions.nonNulls
      .map((element) => element.query)
      .join(' ');
  }

  String buildDeleteQuery (QueryStructure<PsqlClauseStructure> structure) {
    final List<Clause?> instructions = [
      structure.clauses.delete,
      structure.clauses.from,
      ...structure.clauses.where,
    ];

    return instructions.nonNulls
      .map((element) => element.query)
      .join(' ');
  }
}