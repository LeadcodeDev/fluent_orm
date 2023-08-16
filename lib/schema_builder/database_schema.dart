import 'package:fluent_orm/database.dart';
import 'package:fluent_orm/entities/sql_client.dart';
import 'package:fluent_orm/schema_builder/alter_table.dart';
import 'package:fluent_orm/schema_builder/create_table.dart';

class DatabaseSchema {
  final SqlClient _client;
  final Database _database;
  final List<Future<void> Function()> deferred = [];

  DatabaseSchema(this._client, this._database);

  Future createTable (String tableName, Function(CreateTable table) schema) async {
    final table = CreateTable();
    schema(table);

    final columns = table.columnStructure.map((e) => e.query).join(', ');
    final primaryKeys = table.primaryKeys.map((e) => e.query).join(', ');
    final constraints = table.constraints.map((e) => e.query).join(', ');

    final body = [];
    if (columns.isNotEmpty) {
      body.add(columns);
    }

    if (primaryKeys.isNotEmpty) {
      body.add(primaryKeys);
    }

    if (constraints.isNotEmpty) {
      body.add(constraints);
    }

    final arr = ['CREATE TABLE $tableName', "(${body.join(', ')});"];
    await _client.execute(arr.join(' '));
  }

  Future<void> alterTable (String tableName, Function(AlterTable table) schema) async {
    final table = AlterTable();
    schema(table);

    final columns = table.columnStructure.map((e) => e.query).join(', ');
    final primaryKeys = table.primaryKeys.map((e) => e.query).join(', ');
    final constraints = table.constraints.map((e) => e.query).join(', ');

    final body = [];
    if (columns.isNotEmpty) {
      body.add(columns);
    }

    if (primaryKeys.isNotEmpty) {
      body.add(primaryKeys);
    }

    if (constraints.isNotEmpty) {
      body.add(constraints);
    }

    final query = ['ALTER TABLE $tableName', "${body.join(', ')};"].join(' ');
    await _client.execute(query);

    if (table.actions.isNotEmpty) {
      for (final column in table.actions) {
        final query = ['ALTER TABLE $tableName', "${column.query};"];
        await _client.execute(query.join(' '));
      }
    }
  }

  Future<void> renameTable (String tableName, String newName) async {
    await _client.execute('ALTER TABLE $tableName RENAME TO $newName;');
  }

  Future<void> dropTable (String tableName) async {
    await _client.execute('DROP TABLE $tableName;');
  }

  void defer (Future<void> Function(Database manager) callback) {
    callback(_database);
  }
}