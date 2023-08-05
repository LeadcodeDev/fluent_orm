import 'package:fluent_orm/schema_builder/column_modifier.dart';
import 'package:fluent_orm/schema_builder/column_modifiers/primary_modifier.dart';
import 'package:fluent_orm/schema_builder/column_structure.dart';
import 'package:fluent_orm/schema_builder/column_types/increments_column.dart';
import 'package:fluent_orm/schema_builder/column_types/integer_column.dart';
import 'package:fluent_orm/schema_builder/column_types/string_column.dart';
import 'package:fluent_orm/schema_builder/column_types/text_column.dart';

class Table {
  final List<ColumnStructure> columnStructure = [];
  final List<PrimaryModifier> primaryKeys = [];
  final List<ColumnModifier> constraints = [];

  StringColumnContract string (String columnName, { int length = 255 }) {
    final column = StringColumn(this, columnName, length);
    columnStructure.add(column);

    return column;
  }

  TextColumnContract text (String columnName) {
    final column = TextColumn(this, columnName);
    columnStructure.add(column);

    return column;
  }

  IntegerColumnContract integer (String columnName) {
    final column = IntegerColumn(this, columnName);
    columnStructure.add(column);

    return column;
  }

  IncrementsColumn increments (String columnName) {
    final column = IncrementsColumn(columnName);
    columnStructure.add(column);

    return column;
  }
}