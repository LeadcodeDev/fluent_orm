import 'package:postgres/postgres.dart';

abstract class SqlClient {
  Future<void> connect();
  Future<PostgreSQLResult> execute (String query);
}