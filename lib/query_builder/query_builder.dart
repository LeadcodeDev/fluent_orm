import 'package:fluent_orm/contracts/query_builder_contract.dart';
import 'package:fluent_orm/entities/model.dart';
import 'package:fluent_orm/entities/model_builder.dart';
import 'package:fluent_orm/entities/model_wrapper.dart';
import 'package:fluent_orm/fluent_manager.dart';
import 'package:fluent_orm/query_builder/clause_operator.dart';
import 'package:fluent_orm/query_builder/clauses/and_where_clause.dart';
import 'package:fluent_orm/query_builder/clauses/delete_clause.dart';
import 'package:fluent_orm/query_builder/clauses/from_clause.dart';
import 'package:fluent_orm/query_builder/clauses/insert_clause.dart';
import 'package:fluent_orm/query_builder/clauses/insert_many_clause.dart';
import 'package:fluent_orm/query_builder/clauses/into_clause.dart';
import 'package:fluent_orm/query_builder/clauses/limit_clause.dart';
import 'package:fluent_orm/query_builder/clauses/offset_clause.dart';
import 'package:fluent_orm/query_builder/clauses/or_where_clause.dart';
import 'package:fluent_orm/query_builder/clauses/order_by_clause.dart';
import 'package:fluent_orm/query_builder/clauses/returning_clause.dart';
import 'package:fluent_orm/query_builder/clauses/select_clause.dart';
import 'package:fluent_orm/query_builder/clauses/table_clause.dart';
import 'package:fluent_orm/query_builder/clauses/update_clause.dart';
import 'package:fluent_orm/query_builder/clauses/where_clause.dart';
import 'package:fluent_orm/query_builder/declarations/declare_property.dart';
import 'package:fluent_orm/query_builder/declarations/relation.dart';
import 'package:fluent_orm/query_builder/order.dart';
import 'package:fluent_orm/query_builder/preloaded_relation.dart';
import 'package:fluent_orm/query_builder/punctuations/end_punctuation.dart';
import 'package:fluent_orm/query_builder/query_structure.dart';
import 'package:fluent_orm/query_builder/relations/belong_to.dart';
import 'package:fluent_orm/query_builder/relations/has_many.dart';
import 'package:fluent_orm/query_builder/relations/has_one.dart';
import 'package:fluent_orm/query_builder/relations/many_to_many.dart';

class QueryBuilder<T> implements SelectContract<T>, InsertContract<T>, UpdateContract<T>, DeleteContract<T>, HasMany, HasOne, ManyToMany, BelongTo {
  late final FluentManager _manager;
  late final ModelWrapper? _model;
  final QueryStructure structure = QueryStructure();

  QueryBuilder({ required FluentManager manager, ModelWrapper? model }) {
    _manager = manager;
    _model = model;
  }

  @override
  QueryBuilder<T> select({ List<String>? columns }) {
    structure.clauses.select = SelectClause(columns: columns ?? ['*']);
    return this;
  }

  Future<T> insert(Map<String, dynamic> payload) async {
    final ModelWrapper? model = _manager.resolveOrNull<T>();
    final String tableName = model != null
      ?  model.tableName
      : structure.clauses.into!.tableName;

    structure.clauses.insert = InsertClause(tableName, payload);
    structure.clauses.returning = ReturningClause('*');


  }

  QueryBuilder<T> insertMany(List<Map<String, dynamic>> payload) {
    final ModelWrapper? model = _manager.resolveOrNull<T>();
    final String tableName = model != null
      ?  model.tableName
      : structure.clauses.into!.tableName;

    structure.clauses.insert = InsertManyClause(tableName, payload);
    return this;
  }

  QueryBuilder<T> update(Map<String, dynamic> payload) {
    final ModelWrapper? model = _manager.resolveOrNull<T>();
    final String tableName = model != null
      ?  model.tableName
      : structure.clauses.from!.tableName;

    structure.clauses.update = UpdateClause(tableName, payload);
    return this;
  }

  @override
  QueryBuilder<T> where({ required String column, String? operator = '=', required dynamic value }) {
    structure.clauses.select ??= SelectClause(columns: ['*']);

    final targetOperator = ClauseOperator.values.firstWhere((element) => element.uid == operator);

    structure.clauses.where.add(WhereClause(column, targetOperator, value));
    return this;
  }

  @override
  QueryBuilder<T> andWhere({ required String column, String? operator = '=', required dynamic value }) {
    final targetOperator = ClauseOperator.values.firstWhere((element) => element.uid == operator);
    final whereClause = AndWhereClause(column, targetOperator, value);

    structure.clauses.where.add(whereClause);
    return this;
  }

  @override
  QueryBuilder<T> orWhere({ required String column, String? operator = '=', required dynamic value }) {
    final targetOperator = ClauseOperator.values.firstWhere((element) => element.uid == operator);
    final whereClause = OrWhereClause(column, targetOperator, value);

    structure.clauses.where.add(whereClause);
    return this;
  }
  
  @override
  QueryBuilder<T> returning(List<String> columns) {
    structure.clauses.returning = ReturningClause(columns.join(', '));
    return this;
  }
  
  @override
  QueryBuilder<T> limit(int limit) {
    structure.clauses.limit = LimitClause(limit);
    return this;
  }

  QueryBuilder<T> from(String tableName) {
    structure.clauses.from = FromClause(tableName);
    return this;
  }

  QueryBuilder<T> into(String tableName) {
    structure.clauses.into = IntoClause(tableName);
    return this;
  }

  @override
  QueryBuilder<T> table(String tableName) {
    structure.clauses.table = TableClause(tableName);
    return this;
  }

  @override
  QueryBuilder<T> offset(int offset) {
    structure.clauses.offset = OffsetClause(offset);
    return this;
  }

  @override
  QueryBuilder<T> orderBy(String column, { Order direction = Order.asc }) {
    structure.clauses.order.add(OrderByClause(column, direction));
    return this;
  }

  @override
  QueryBuilder<T> preload<M extends Model, R extends RelationContract>({ Function(R queryBuilder)? query }) {
    final relatedModel = _manager.resolve<M>();
    final preloadBuilder = switch (R) {
      HasMany => HasManyRelation<M>(_manager, _model, relatedModel),
      HasOne => HasOneRelation<M>(_manager, _model, relatedModel),
      ManyToMany => ManyToManyRelation<M>(_manager, _model, relatedModel),
      BelongTo => BelongToRelation<M>(_manager, _model, relatedModel),
      _ => throw Exception('Relation $R is not supported')
    };

    if (query != null) {
      query(preloadBuilder as R);
    }

    structure.preloads.add(
      PreloadRelation<M, R>(
        _manager,
        (value) => (preloadBuilder as dynamic).build(value),
        R
      )
    );

    return this;
  }

  List<String?> get _selectClauses => [
    structure.clauses.select?.query,
    structure.clauses.from?.query,
    ...structure.clauses.where.map((e) => e.query),
    ...structure.clauses.order.map((e) => e.query),
    structure.clauses.limit?.query,
    structure.clauses.offset?.query,
    EndPunctuation().query,
  ];

  @override
  Future<List<T>> all () async {
    return switch (T) {
      dynamic => _manager.request.commitWithoutModel<List<T>>(query: _selectClauses.nonNulls.join(' ')),
      _ => _manager.request.commit<List<T>, T>(query: _selectClauses.nonNulls.join(' '))
    };
  }

  @override
  Future<T?> first () async {
    _selectClauses.insert(_selectClauses.length, LimitClause(1).query);

    final ModelWrapper? model = _manager.resolveOrNull<T>();
    structure.clauses.from = FromClause(model != null
      ?  model.tableName
      : structure.clauses.from!.tableName);

    structure.clauses.select ??= SelectClause(columns: ['*']);

    final result = switch (T) {
      dynamic => _manager.request.commitWithoutModel<T?>(query: _selectClauses.nonNulls.join(' '), first: true),
      _ => _manager.request.commit<T, T>(preloads: structure.preloads, query: _selectClauses.nonNulls.join(' '))
    };

    return result;
  }

  @override
  Future<T> firstOrFail () async {
    final result = await first();

    if (result == null) {
      throw Exception('No results found');
    }

    return result;
  }

  @override
  Future<T> save () async {
    final model = _manager.resolveOrNull<T>();

    if (model != null) {
      final builder = ModelBuilder()
        ..bucket.addAll(structure.clauses.insert?.payload);

      model.hooks.beforeCreate(builder);
      
      structure.clauses.insert?.payload = builder.bucket;
    }

    final query = [
      structure.clauses.insert?.query,
      ...structure.clauses.where.map((e) => e.query),
      structure.clauses.returning?.query,
    ];

    return switch (T) {
      dynamic => _manager.request.commitWithoutModel<T>(query: query.nonNulls.join(' '), first: true),
      _ => _manager.request.commit<T, T>(query: query.nonNulls.join(' '))
    };
  }

  @override
  Future<List<T>> saveMany () async {
    final query = [
      structure.clauses.insert?.query,
      ...structure.clauses.where.map((e) => e.query),
      structure.clauses.returning?.query,
    ];

    return switch (T) {
      dynamic => _manager.request.commitWithoutModel<List<T>>(query: query.nonNulls.join(' ')),
      _ => _manager.request.commit<List<T>, T>(query: query.nonNulls.join(' '))
    };
  }

  @override
  Future<T> put () async {
    final query = [
      structure.clauses.update?.query,
      ...structure.clauses.where.map((e) => e.query),
      structure.clauses.returning?.query,
    ];

    return switch (T) {
      dynamic => _manager.request.commitWithoutModel(query: query.nonNulls.join(' ')),
      _ => _manager.request.commit<T, T>(query: query.nonNulls.join(' '))
    } as Future<T>;
  }

  @override
  Future<void> del () async {
    final ModelWrapper? model = _manager.resolveOrNull<T>();
    structure.clauses.delete = DeleteClause(model != null
      ?  model.tableName
      : structure.clauses.from!.tableName);

    final query = [
      structure.clauses.delete?.query,
      ...structure.clauses.where.map((e) => e.query),
      structure.clauses.returning?.query,
    ];

    await _manager.client.execute(query.nonNulls.join(' '));
  }
}