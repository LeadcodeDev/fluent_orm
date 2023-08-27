import 'package:fluent_orm/clients/psql/schema/psql_alter_table.dart';
import 'package:fluent_orm/clients/psql/schema/psql_create_table.dart';
import 'package:fluent_orm/clients/common/database.dart';
import 'package:fluent_orm/clients/common/abstract_database_schema.dart';
import 'package:fluent_orm/clients/common/abstract_provider.dart';

class PsqlDatabaseSchema implements AbstractDatabaseSchema {
  final AbstractProvider _provider;
  final Database _database;
  final List<Future<void> Function()> deferred = [];

  PsqlDatabaseSchema(this._provider, this._database);

  @override
  Future createTable (String tableName, Function(PsqlCreateTable table) schema) async {
    final table = PsqlCreateTable();
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
    await _provider.execute(arr.join(' '));
  }

  @override
  Future<void> alterTable (String tableName, Function(PsqlAlterTable table) schema) async {
    final table = PsqlAlterTable();
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
    await _provider.execute(query);

    if (table.actions.isNotEmpty) {
      for (final column in table.actions) {
        final query = ['ALTER TABLE $tableName', "${column.query};"];
        await _provider.execute(query.join(' '));
      }
    }
  }

  @override
  Future<void> renameTable (String tableName, String newName) async {
    await _provider.execute('ALTER TABLE $tableName RENAME TO $newName;');
  }

  @override
  Future<void> dropTable (String tableName) async {
    await _provider.execute('DROP TABLE $tableName;');
  }

  @override
  void defer (Future<void> Function(Database manager) callback) {
    callback(_database);
  }
}