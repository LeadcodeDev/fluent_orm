import 'package:fluent_orm/clients/common/abstract_query_builder.dart';
import 'package:fluent_orm/clients/common/abstract_standalone_query_builder.dart';

abstract class AbstractModelQueryBuilder<T> implements AbstractQueryBuilder<T> {
  AbstractStandaloneQueryBuilder<T> query();
  Future<T> create(Map<String, dynamic> payload);
  Future<List<T>> createMany(List<Map<String, dynamic>> payload);

  Future<T?> find(dynamic id);
  Future<T?> findBy({ required String column, String operator = '=', required dynamic value });

  Future<T> findOrFail(dynamic value);
  Future<T> findByOrFail({ required String column, String operator = '=', required dynamic value });

  Future<T?> first (dynamic value);
  Future<T> firstOrFail (dynamic value);

  Future<List<T>> all ();
}