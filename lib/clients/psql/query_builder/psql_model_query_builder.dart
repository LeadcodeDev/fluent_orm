import 'package:fluent_orm/clients/psql/query_builder/psql_clause_structure.dart';
import 'package:fluent_orm/fluent_manager.dart';
import 'package:fluent_orm/clients/common/abstract_model_query_builder.dart';
import 'package:fluent_orm/clients/common/abstract_standalone_query_builder.dart';
import 'package:fluent_orm/clients/psql/query_builder/clauses/from_clause.dart';
import 'package:fluent_orm/clients/psql/query_builder/clauses/insert_clause.dart';
import 'package:fluent_orm/clients/psql/query_builder/clauses/into_clause.dart';
import 'package:fluent_orm/clients/psql/query_builder/clauses/limit_clause.dart';
import 'package:fluent_orm/clients/psql/query_builder/clauses/returning_clause.dart';
import 'package:fluent_orm/clients/psql/query_builder/clauses/select_clause.dart';
import 'package:fluent_orm/clients/psql/query_builder/clauses/values_clause.dart';
import 'package:fluent_orm/clients/psql/query_builder/clauses/where_clause.dart';
import 'package:fluent_orm/clients/common/model_wrapper.dart';
import 'package:fluent_orm/clients/common/query_structure.dart';
import 'package:fluent_orm/clients/psql/query_builder/psql_query_builder.dart';

class PsqlModelQueryBuilder<T> implements AbstractModelQueryBuilder<T> {
  final QueryStructure<PsqlClauseStructure> _structure = QueryStructure(PsqlClauseStructure());
  final FluentManager _manager;
  final ModelWrapper _baseModel;

  PsqlModelQueryBuilder(this._manager, this._baseModel);

  @override
  AbstractStandaloneQueryBuilder<T> query() => PsqlQueryBuilder(_manager)
    ..from(_baseModel.tableName)
    ..table(_baseModel.tableName)
    ..select();

  @override
  Future<T> create(Map<String, dynamic> payload) async {
    _structure.clauses
      ..insert = InsertClause()
      ..into = IntoClause(_baseModel.tableName)
      ..values = ValuesClause(payload)
      ..returning = ReturningClause('*');

    final query = _manager.request.buildInsertQuery(_structure);

    final properties = await _manager.request.commit<Map<String, dynamic>>(query);
    final model = _manager.request.assignToModel<T>(properties!);
    _manager.request.applyPreloads(model, _structure.preloads);

    return model;
  }

  @override
  Future<List<T>> createMany(List<Map<String, dynamic>> payload) async {
    _structure.clauses
      ..insert = InsertClause()
      ..into = IntoClause(_baseModel.tableName)
      ..values = ValuesClause(payload)
      ..returning = ReturningClause('*');

    final query = _manager.request.buildInsertQuery(_structure);
    final properties = await _manager.request.commit<List>(query);

    final models = List<T>.from(properties!.map((element) => _manager.request.assignToModel<T>(element)));
    for (final model in models) {
      _manager.request.applyPreloads(model, _structure.preloads);
    }

    return models;
  }

  @override
  Future<T?> find(dynamic value) async {
    _structure.clauses
      ..select = SelectClause(['*'])
      ..from = FromClause(_baseModel.tableName)
      ..where.add(WhereClause('id', '=', value))
      ..limit = LimitClause(1);

    final query = _manager.request.buildSelectQuery(_structure);
    final properties = await _manager.request.commit<Map<String, dynamic>>(query);

    if (properties == null) {
      return null;
    }

    final model = _manager.request.assignToModel<T>(properties);
    _manager.request.applyPreloads(model, _structure.preloads);

    return model;
  }

  @override
  Future<T> findOrFail(dynamic value) async {
    final result = await find(value);

    if (result == null) {
      throw Exception('No results found');
    }

    return result;
  }

  @override
  Future<T?> findBy({ required String column, String operator = '=', required dynamic value }) async {
    _structure.clauses
      ..select = SelectClause(['*'])
      ..from = FromClause(_baseModel.tableName)
      ..where.add(WhereClause(column, operator, value))
      ..limit = LimitClause(1);

    final query = _manager.request.buildSelectQuery(_structure);
    final properties = await _manager.request.commit<Map<String, dynamic>>(query);

    if (properties == null) {
      return null;
    }

    final model = _manager.request.assignToModel<T>(properties);
    _manager.request.applyPreloads(model, _structure.preloads);

    return model;
  }

  @override
  Future<T> findByOrFail({ required String column, String operator = '=', required dynamic value }) async {
    final result = await findBy(column: column, operator: operator, value: value);

    if (result == null) {
      throw Exception('No results found');
    }

    return result;
  }

  @override
  Future<T?> first (dynamic value) async {
    _structure.clauses
      ..select = SelectClause(['*'])
      ..from = FromClause(_baseModel.tableName)
      ..limit = LimitClause(1);

    final query = _manager.request.buildSelectQuery(_structure);
    final properties = await _manager.request.commit<Map<String, dynamic>>(query);

    if (properties == null) {
      return null;
    }

    final model = _manager.request.assignToModel<T>(properties);
    _manager.request.applyPreloads(model, _structure.preloads);

    return model;
  }

  @override
  Future<T> firstOrFail (dynamic value) async {
   final result = await first(value);

   if (result == null) {
     throw Exception('No results found');
   }

    return result;
  }

  @override
  Future<List<T>> all () async {
    _structure.clauses
      ..select = SelectClause(['*'])
      ..from = FromClause(_baseModel.tableName);

    final query = _manager.request.buildSelectQuery(_structure);
    final properties = await _manager.request.commit<List>(query);

    final models = List<T>.from(properties!.map((element) => _manager.request.assignToModel<T>(element)));
    for (final model in models) {
      _manager.request.applyPreloads(model, _structure.preloads);
    }

    return models;
  }
}