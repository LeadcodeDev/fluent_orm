import 'package:fluent_orm/clients/common/abstract_query_builder.dart';
import 'package:fluent_orm/clients/common/model.dart';
import 'package:fluent_orm/clients/common/order.dart';

import 'declarations/relation.dart';

abstract class AbstractStandaloneQueryBuilder<T> implements AbstractQueryBuilder<T> {
  AbstractStandaloneQueryBuilder<T> select({ List<String> columns = const ['*'] });
  AbstractStandaloneQueryBuilder<T> from(String table);

  AbstractStandaloneQueryBuilder<T> where({ required String column, String operator = '=', required dynamic value });
  AbstractStandaloneQueryBuilder<T> andWhere({ required String column, String operator = '=', required dynamic value });
  AbstractStandaloneQueryBuilder<T> orWhere({ required String column, String operator = '=', required dynamic value });
  AbstractStandaloneQueryBuilder<T> whereIn({ required String column, required List values });

  AbstractStandaloneQueryBuilder<T> returning(List<String> columns);
  AbstractStandaloneQueryBuilder<T> offset(int offset);
  AbstractStandaloneQueryBuilder<T> limit(int limit);
  AbstractStandaloneQueryBuilder<T> orderBy(String column, Order direction);
  AbstractStandaloneQueryBuilder<T> table (String tableName);

  Future<List<T>> fetch();
  Future<T?> first();

  Future<T> insert(Map<String, dynamic> payload);
  Future<List<T>> insertMany(List<Map<String, dynamic>> payload);

  Future<T> update (Map<String, dynamic> payload);
  Future<void> del ();

  AbstractStandaloneQueryBuilder<T> preload<M extends Model, R extends RelationContract> ({ void Function(AbstractStandaloneQueryBuilder<M> query)? query });
}