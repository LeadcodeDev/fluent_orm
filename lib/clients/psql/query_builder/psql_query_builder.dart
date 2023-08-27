import 'package:fluent_orm/clients/psql/query_builder/psql_clause_structure.dart';
import 'package:fluent_orm/fluent_manager.dart';
import 'package:fluent_orm/clients/common/abstract_standalone_query_builder.dart';
import 'package:fluent_orm/clients/psql/query_builder/clauses/and_where_clause.dart';
import 'package:fluent_orm/clients/psql/query_builder/clauses/delete_clause.dart';
import 'package:fluent_orm/clients/psql/query_builder/clauses/from_clause.dart';
import 'package:fluent_orm/clients/psql/query_builder/clauses/insert_clause.dart';
import 'package:fluent_orm/clients/psql/query_builder/clauses/into_clause.dart';
import 'package:fluent_orm/clients/psql/query_builder/clauses/limit_clause.dart';
import 'package:fluent_orm/clients/psql/query_builder/clauses/offset_clause.dart';
import 'package:fluent_orm/clients/psql/query_builder/clauses/or_where_clause.dart';
import 'package:fluent_orm/clients/psql/query_builder/clauses/order_by_clause.dart';
import 'package:fluent_orm/clients/psql/query_builder/clauses/returning_clause.dart';
import 'package:fluent_orm/clients/psql/query_builder/clauses/select_clause.dart';
import 'package:fluent_orm/clients/psql/query_builder/clauses/set_clause.dart';
import 'package:fluent_orm/clients/psql/query_builder/clauses/table_clause.dart';
import 'package:fluent_orm/clients/psql/query_builder/clauses/update_clause.dart';
import 'package:fluent_orm/clients/psql/query_builder/clauses/values_clause.dart';
import 'package:fluent_orm/clients/psql/query_builder/clauses/where_clause.dart';
import 'package:fluent_orm/clients/psql/query_builder/clauses/where_in_clause.dart';
import 'package:fluent_orm/clients/common/declarations/relation.dart';
import 'package:fluent_orm/clients/common/model.dart';
import 'package:fluent_orm/clients/common/order.dart';
import 'package:fluent_orm/clients/common/preloaded_relation.dart';
import 'package:fluent_orm/clients/common/query_structure.dart';
import 'package:fluent_orm/clients/psql/query_builder/relations/belong_to.dart';
import 'package:fluent_orm/clients/psql/query_builder/relations/has_many.dart';
import 'package:fluent_orm/clients/psql/query_builder/relations/has_one.dart';
import 'package:fluent_orm/clients/psql/query_builder/relations/many_to_many.dart';

class PsqlQueryBuilder<T> implements AbstractStandaloneQueryBuilder<T> {
  final QueryStructure<PsqlClauseStructure> _structure = QueryStructure(PsqlClauseStructure());
  final FluentManager _manager;

  PsqlQueryBuilder(this._manager);

  @override
  PsqlQueryBuilder<T> select({ List<String> columns = const ['*'] }) {
    _structure.clauses.select = SelectClause(columns);
    return this;
  }

  @override
  PsqlQueryBuilder<T> from(String tableName) {
    _structure.clauses.from = FromClause(tableName);
    return this;
  }

  @override
  PsqlQueryBuilder<T> where({required String column, String operator = '=', required value}) {
    _structure.clauses.where.add(WhereClause(column, operator, value));
    return this;
  }

  @override
  PsqlQueryBuilder<T> andWhere({required String column, String operator = '=', required value}) {
    if (_structure.clauses.where.isEmpty) {
      return where(column: column, operator: operator, value: value);
    }

    _structure.clauses.where.add(AndWhereClause(column, operator, value));
    return this;
  }

  @override
  PsqlQueryBuilder<T> orWhere({required String column, String operator = '=', required value}) {
    if (_structure.clauses.where.isEmpty) {
      return where(column: column, operator: operator, value: value);
    }

    _structure.clauses.where.add(OrWhereClause(column, operator, value));
    return this;
  }

  @override
  PsqlQueryBuilder<T> whereIn({ required String column, required List values }) {
    _structure.clauses.where.add(WhereInClause(column, values));
    return this;
  }

  @override
  PsqlQueryBuilder<T> limit(int limit) {
    _structure.clauses.limit = LimitClause(limit);
    return this;
  }

  @override
  PsqlQueryBuilder<T> offset(int offset) {
    _structure.clauses.offset = OffsetClause(offset);
    return this;
  }

  @override
  PsqlQueryBuilder<T> orderBy(String column, Order direction) {
    _structure.clauses.order.add(OrderByClause(column, direction));
    return this;
  }

  @override
  PsqlQueryBuilder<T> returning(List<String> columns) {
    _structure.clauses.returning = ReturningClause(columns.join(', '));
    return this;
  }

  @override
  PsqlQueryBuilder<T> table(String tableName) {
    _structure.clauses
      ..table = TableClause(tableName)
      ..insert = InsertClause()
      ..into = IntoClause(tableName)
      ..from = FromClause(tableName);

    return this;
  }

  @override
  Future<T> insert (Map<String, dynamic> payload) async {
    _structure.clauses.values = ValuesClause(payload);

    final query = _manager.request.buildInsertQuery(_structure);
    final result = await _manager.request.commit<Map<String, dynamic>>(query);

    if (T == dynamic) {
      return result as T;
    }

    return _manager.request.assignToModel<T>(result!);
  }

  @override
  Future<List<T>> insertMany(List<Map<String, dynamic>> payload) async {
    _structure.clauses.values = ValuesClause(payload);

    final query = _manager.request.buildInsertQuery(_structure);
    final result = await _manager.request.commit<List>(query);

    if (T == dynamic) {
      return result as List<T>;
    }

    return result!
      .map((value) => _manager.request.assignToModel<T>(value))
      .toList();
  }

  @override
  Future<List<T>> fetch() async {
    final query = _manager.request.buildSelectQuery(_structure);
    final result = await _manager.request.commit<List>(query);

    if (T == dynamic) {
      return result as List<T>;
    }

    return List<T>.from(result!.map((element) => _manager.request.assignToModel<T>(element)));
  }

  @override
  Future<T?> first() async {
    _structure.clauses.limit = LimitClause(1);

    final query = _manager.request.buildSelectQuery(_structure);
    final result = await _manager.request.commit<dynamic>(query);

    if (T == dynamic) {
      return result;
    }

    final model = _manager.request.assignToModel<T>(result);
    await _manager.request.applyPreloads(model, _structure.preloads);

    return model;
  }

  @override
  Future<T> update(Map<String, dynamic> payload) async {
    _structure.clauses
      ..update = UpdateClause()
      ..set = SetClause(payload);

    final query = _manager.request.buildUpdateQuery(_structure);
    final result = await _manager.request.commit<dynamic>(query);

    if (T == dynamic) {
      return result;
    }

    return _manager.request.assignToModel<T>(result);
  }
  
  @override
  Future<void> del () async {
    _structure.clauses.delete = DeleteClause();

    final query = _manager.request.buildDeleteQuery(_structure);
    await _manager.provider.execute(query);
  }

  @override
  PsqlQueryBuilder<T> preload<M extends Model, R extends RelationContract> ({ void Function(AbstractStandaloneQueryBuilder<M> query)? query }) {
    final baseModel = _manager.resolve<T>();
    final relatedModel = _manager.resolveOrNull<M>();

    if (relatedModel == null) {
      throw Exception('You cannot preload relations without a valid model');
    }

    final queryBuilder = PsqlQueryBuilder<M>(_manager);

    final preloadBuilder = switch (R) {
      HasMany => HasManyRelation<M>(_manager, queryBuilder, queryBuilder._structure, baseModel, relatedModel),
      HasOne => HasOneRelation<M>(_manager, queryBuilder, queryBuilder._structure, baseModel, relatedModel),
      ManyToMany => ManyToManyRelation<M>(_manager, queryBuilder, queryBuilder._structure, baseModel, relatedModel),
      BelongTo => BelongToRelation<M>(_manager, queryBuilder, queryBuilder._structure, baseModel, relatedModel),
      _ => throw Exception('Relation $R is not supported'),
    };

    if (query != null) {
      query(queryBuilder);
    }

    _structure.preloads.add(PreloadRelation((value) => preloadBuilder.build(value), M, R));
    return this;
  }
}