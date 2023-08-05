import 'package:fluent_orm/schema_builder/table.dart';

class DatabaseSchema {
  final Table _table = Table();

  void createTable (String tableName, Function(Table table) schema) {
    schema(_table);

    final columns = _table.columnStructure.map((e) => e.query).join(', ');
    final primaryKeys = _table.primaryKeys.map((e) => e.query).join(', ');

    final body = [];
    if (columns.isNotEmpty) {
      body.add(columns);
    }

    if (primaryKeys.isNotEmpty) {
      body.add(primaryKeys);
    }

    final arr = ['CREATE TABLE $tableName', "(${body.join(', ')});"];
    print(arr.join(' '));
  }
}