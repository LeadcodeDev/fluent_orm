import 'package:fluent_orm/clients/common/abstract_database_schema.dart';
import 'package:fluent_orm/clients/common/abstract_provider.dart';
import 'package:fluent_orm/clients/common/database.dart';
import 'package:fluent_orm/clients/common/model_wrapper.dart';
import 'package:fluent_orm/clients/psql/query_builder/psql_model_query_builder.dart';
import 'package:fluent_orm/clients/psql/query_builder/psql_query_builder.dart';
import 'package:fluent_orm/clients/psql/schema/database_schema.dart';
import 'package:fluent_orm/fluent_manager.dart';
import 'package:postgres/postgres.dart';

class PostgresProvider extends AbstractProvider {
  late final PostgreSQLConnection connexion;

  final String host;
  final int port;
  final String database;

  final String? user;
  final String? password;

  PostgresProvider({
    required this.host,
    required this.port,
    required this.database,
    this.user,
    this.password
  });

  @override
  PsqlQueryBuilder<T> makeQueryBuilder<T> (FluentManager manager) => PsqlQueryBuilder<T>(manager);

  @override
  PsqlModelQueryBuilder<T> makeModelQueryBuilder<T> (FluentManager manager, ModelWrapper model) =>
    PsqlModelQueryBuilder<T>(manager, model);

  @override
  AbstractDatabaseSchema makeSchema (Database database) => DatabaseSchema(this, database);

  @override
  Future<void> connect() async {
    connexion = PostgreSQLConnection(host, port, database, username: user, password: password);
    await connexion.open();
  }

  @override
  Future<PostgreSQLResult> execute(String query) {
    return connexion.query(query);
  }
}