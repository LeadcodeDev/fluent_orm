import 'package:fluent_orm/fluent_manager.dart';
import 'package:fluent_orm/schema_builder/table.dart';

class DatabaseSchema {
  final FluentManager _manager;
  final Table _table = Table();

  DatabaseSchema(this._manager);

  Future createTable (String tableName, Function(Table table) schema) async {
    schema(_table);

    final columns = _table.columnStructure.map((e) => e.query).join(', ');
    final primaryKeys = _table.primaryKeys.map((e) => e.query).join(', ');
    final constraints = _table.constraints.map((e) => e.query).join(', ');

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
    print(arr.join(' '));
    await _manager.client.execute(arr.join(' '));
  }
}