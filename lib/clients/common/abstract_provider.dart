import 'package:fluent_orm/clients/common/abstract_database_schema.dart';
import 'package:fluent_orm/clients/common/abstract_model_query_builder.dart';
import 'package:fluent_orm/clients/common/abstract_query_builder.dart';
import 'package:fluent_orm/clients/common/database.dart';
import 'package:fluent_orm/clients/common/model_wrapper.dart';
import 'package:fluent_orm/fluent_manager.dart';
import 'package:postgres/postgres.dart';

abstract class AbstractProvider {
  AbstractQueryBuilder<T> makeQueryBuilder<T> (FluentManager manager);
  AbstractModelQueryBuilder<T> makeModelQueryBuilder<T> (FluentManager manager, ModelWrapper model);
  AbstractDatabaseSchema makeSchema (Database database);
  Future<void> connect();
  Future<PostgreSQLResult> execute (String query);
}