import 'package:fluent_orm/schema_builder/column_modifier.dart';
import 'package:fluent_orm/schema_builder/column_modifiers/default_to_modifier.dart';
import 'package:fluent_orm/schema_builder/column_modifiers/primary_modifier.dart';
import 'package:fluent_orm/schema_builder/column_structure.dart';
import 'package:fluent_orm/schema_builder/column_types/bool_column.dart';
import 'package:fluent_orm/schema_builder/column_types/date_column.dart';
import 'package:fluent_orm/schema_builder/column_types/increments_column.dart';
import 'package:fluent_orm/schema_builder/column_types/integer_column.dart';
import 'package:fluent_orm/schema_builder/column_types/string_column.dart';
import 'package:fluent_orm/schema_builder/column_types/text_column.dart';
import 'package:fluent_orm/schema_builder/column_types/time_column.dart';
import 'package:fluent_orm/schema_builder/column_types/timestamp_column.dart';
import 'package:fluent_orm/schema_builder/column_types/uuid_column.dart';

class Table {
  final List<ColumnStructure> columnStructure = [];
  final List<PrimaryModifier> primaryKeys = [];
  final List<ColumnModifier> constraints = [];

  StringColumnContract string (String columnName, { int length = 255 }) {
    final column = StringColumn(this, columnName, length);
    columnStructure.add(column);

    return column;
  }

  UuidColumnContract uuid (String columnName, { int length = 255 }) {
    final column = UuidColumn(this, columnName, length);
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

  BoolColumnContract boolean (String columnName) {
    final column = BoolColumn(columnName);
    columnStructure.add(column);

    return column;
  }

  IncrementsColumn increments (String columnName) {
    final column = IncrementsColumn(columnName);
    columnStructure.add(column);

    return column;
  }

  TimestampColumnContract timestamp (String columnName) {
    final column = TimestampColumn(columnName)
      ..modifiers.add(DefaultToModifier('(now() at time zone \'utc\')'));

    columnStructure.add(column);

    return column;
  }

  DateColumnContract date (String columnName) {
    final column = DateColumn(columnName);
    columnStructure.add(column);

    return column;
  }

  DateTimeColumnContract dateTime (String columnName) {
    final column = DateTimeColumn(columnName);
    columnStructure.add(column);

    return column;
  }
}