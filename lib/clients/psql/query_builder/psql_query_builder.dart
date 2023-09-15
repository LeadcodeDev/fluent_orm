import 'package:fluent_orm/clients/psql/query_builder/clauses/and_where_between_clause.dart';
import 'package:fluent_orm/clients/psql/query_builder/clauses/and_where_in_clause.dart';
import 'package:fluent_orm/clients/psql/query_builder/clauses/and_where_not_between_clause.dart';
import 'package:fluent_orm/clients/psql/query_builder/clauses/and_where_not_in_clause.dart';
import 'package:fluent_orm/clients/psql/query_builder/clauses/or_where_between_clause.dart';
import 'package:fluent_orm/clients/psql/query_builder/clauses/or_where_in_clause.dart';
import 'package:fluent_orm/clients/psql/query_builder/clauses/or_where_not_between_clause.dart';
import 'package:fluent_orm/clients/psql/query_builder/clauses/or_where_not_clause.dart';
import 'package:fluent_orm/clients/psql/query_builder/clauses/or_where_not_in_clause.dart';
import 'package:fluent_orm/clients/psql/query_builder/clauses/where_between_clause.dart';
import 'package:fluent_orm/clients/psql/query_builder/clauses/where_not_between_clause.dart';
import 'package:fluent_orm/clients/psql/query_builder/clauses/where_not_in_clause.dart';
import 'package:fluent_orm/clients/psql/query_builder/psql_clause_structure.dart';
import 'package:fluent_orm/clients/psql/query_builder/psql_pagination.dart';
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
  AbstractStandaloneQueryBuilder<T> andWhereNull({ required String column }) {
    if (_structure.clauses.where.isEmpty) {
      return where(column: column, operator: 'IS', value: 'NULL');
    }

    _structure.clauses.where.add(AndWhereClause(column, 'IS', 'NULL'));
    return this;
  }

  @override
  AbstractStandaloneQueryBuilder<T> andWhereBetween({required String column, required start, required end}) {
    if (_structure.clauses.where.isEmpty) {
      return whereBetween(column: column, start: start, end: end);
    }

    _structure.clauses.where.add(AndWhereBetweenClause(column, start, end));
    return this;
  }

  @override
  AbstractStandaloneQueryBuilder<T> andWhereIn({required String column, required List values }) {
    if (_structure.clauses.where.isEmpty) {
      return whereIn(column: column, values: values);
    }

    _structure.clauses.where.add(AndWhereInClause(column, values));
    return this;
  }

  @override
  AbstractStandaloneQueryBuilder<T> andWhereNot({required String column, required dynamic value }) {
    if (_structure.clauses.where.isEmpty) {
      return whereNot(column: column, value: value);
    }

    _structure.clauses.where.add(AndWhereClause(column, 'NOT', value));
    return this;
  }

  @override
  AbstractStandaloneQueryBuilder<T> andWhereNotBetween({required String column, required start, required end}) {
    if (_structure.clauses.where.isEmpty) {
      return whereBetween(column: column, start: start, end: end);
    }

    _structure.clauses.where.add(AndWhereNotBetweenClause(column, start, end));
    return this;
  }

  @override
  AbstractStandaloneQueryBuilder<T> andWhereNotIn({required String column, required List values}) {
    if (_structure.clauses.where.isEmpty) {
      return whereNotIn(column: column, values: values);
    }

    _structure.clauses.where.add(AndWhereNotInClause(column, values));
    return this;
  }

  @override
  AbstractStandaloneQueryBuilder<T> andWhereNotNull({required String column}) {
    if (_structure.clauses.where.isEmpty) {
      return where(column: column, operator: '=', value: null);
    }

    _structure.clauses.where.add(AndWhereClause(column, 'IS NOT', null));
    return this;
  }

  @override
  AbstractStandaloneQueryBuilder<T> orWhereBetween({required String column, required int start, required int end}) {
    if (_structure.clauses.where.isEmpty) {
      return whereBetween(column: column, start: start, end: end);
    }

    _structure.clauses.where.add(OrWhereBetweenClause(column, start, end));
    return this;
  }

  @override
  AbstractStandaloneQueryBuilder<T> orWhereIn({required String column, required List values}) {
    if (_structure.clauses.where.isEmpty) {
      return whereIn(column: column, values: values);
    }

    _structure.clauses.where.add(OrWhereInClause(column, values));
    return this;
  }

  @override
  AbstractStandaloneQueryBuilder<T> orWhereNot({required String column, required value }) {
    if (_structure.clauses.where.isEmpty) {
      return whereNot(column: column, value: value);
    }

    _structure.clauses.where.add(OrWhereNotClause(column, value));
    return this;
  }

  @override
  AbstractStandaloneQueryBuilder<T> orWhereNotBetween({required String column, required int start, required int end}) {
    if (_structure.clauses.where.isEmpty) {
      return whereBetween(column: column, start: start, end: end);
    }

    _structure.clauses.where.add(OrWhereNotBetweenClause(column, start, end));
    return this;
  }

  @override
  AbstractStandaloneQueryBuilder<T> orWhereNotIn({required String column, required List values}) {
    if (_structure.clauses.where.isEmpty) {
      return whereNotIn(column: column, values: values);
    }

    _structure.clauses.where.add(OrWhereNotInClause(column, values));
    return this;
  }

  @override
  AbstractStandaloneQueryBuilder<T> orWhereNotNull({required String column}) {
    if (_structure.clauses.where.isEmpty) {
      return where(column: column, operator: 'IS NOT', value: null);
    }

    _structure.clauses.where.add(OrWhereClause(column, 'IS NOT', null));
    return this;
  }

  @override
  AbstractStandaloneQueryBuilder<T> orWhereNull({ required String column }) {
    if (_structure.clauses.where.isEmpty) {
      return whereNull(column: column);
    }

    _structure.clauses.where.add(OrWhereClause(column, 'IS', 'NULL'));
    return this;
  }

  @override
  AbstractStandaloneQueryBuilder<T> whereBetween({required String column, required int start, required int end}) {
    _structure.clauses.where.add(WhereBetweenClause(column, start, end));
    return this;
  }

  @override
  AbstractStandaloneQueryBuilder<T> whereNot({required String column, required value}) {
    _structure.clauses.where.add(WhereClause(column, 'IS NOT', value));
    return this;
  }

  @override
  AbstractStandaloneQueryBuilder<T> whereNotBetween({required String column, required int start, required int end}) {
    _structure.clauses.where.add(WhereNotBetweenClause(column, start, end));
    return this;
  }

  @override
  AbstractStandaloneQueryBuilder<T> whereNotIn({required String column, required List values }) {
    _structure.clauses.where.add(WhereNotInClause(column, values));
    return this;
  }

  @override
  AbstractStandaloneQueryBuilder<T> whereNotNull({ required String column }) {
    if (_structure.clauses.where.isEmpty) {
      return where(column: column, operator: 'IS NOT', value: null);
    }

    _structure.clauses.where.add(AndWhereClause(column, 'IS NOT', null));
    return this;
  }

  @override
  AbstractStandaloneQueryBuilder<T> whereNull({required String column}) {
    if (_structure.clauses.where.isEmpty) {
      return where(column: column, operator: 'IS', value: null);
    }

    _structure.clauses.where.add(AndWhereClause(column, 'IS', null));
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

  @override
  Future<PsqlPagination<T>> paginate ({ required int page, int itemsPerPage = 10 }) async {
    final countQuery = _manager.request.buildSelectQuery(_structure);
    final countResult = await _manager.request.commit<List>(countQuery);

    final int lastPage = (countResult!.length / itemsPerPage).ceil();

    _structure.clauses
      ..limit = LimitClause(itemsPerPage)
      ..offset = OffsetClause((page - 1) * itemsPerPage);

    final query = _manager.request.buildSelectQuery(_structure);
    final result = await _manager.request.commit<List>(query);

    _structure.clauses
      ..limit = null
      ..offset = null;

    if (T == dynamic) {
      return PsqlPagination(_structure, _manager,
        currentPage: page,
        firstPage: page,
        lastPage: lastPage,
        itemsPerPage: itemsPerPage,
        data: List<T>.from(result ?? []),
      );
    }

    return PsqlPagination<T>(_structure, _manager,
      currentPage: page,
      firstPage: page,
      lastPage: lastPage,
      itemsPerPage: itemsPerPage,
      data: List<T>.from(result!.map((element) => _manager.request.assignToModel<T>(element)))
    );
  }
}