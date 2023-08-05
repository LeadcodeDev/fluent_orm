import 'package:fluent_orm/entities/sql_client.dart';
import 'package:postgres/postgres.dart';

class PostgresClient extends SqlClient {
  late final PostgreSQLConnection connexion;

  final String host;
  final int port;
  final String database;

  final String? user;
  final String? password;

  PostgresClient({
    required this.host,
    required this.port,
    required this.database,
    this.user,
    this.password
  });

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