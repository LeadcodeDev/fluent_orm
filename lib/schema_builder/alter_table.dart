import 'package:fluent_orm/schema_builder/abstract_table.dart';
import 'package:fluent_orm/schema_builder/column_modifier.dart';
import 'package:fluent_orm/schema_builder/column_modifiers/default_to_modifier.dart';
import 'package:fluent_orm/schema_builder/column_modifiers/drop_column_modifier.dart';
import 'package:fluent_orm/schema_builder/column_modifiers/drop_contraint_modifier.dart';
import 'package:fluent_orm/schema_builder/column_modifiers/rename_column_modifier.dart';
import 'package:fluent_orm/schema_builder/column_types/bool_column.dart';
import 'package:fluent_orm/schema_builder/column_types/date_column.dart';
import 'package:fluent_orm/schema_builder/column_types/increments_column.dart';
import 'package:fluent_orm/schema_builder/column_types/integer_column.dart';
import 'package:fluent_orm/schema_builder/column_types/string_column.dart';
import 'package:fluent_orm/schema_builder/column_types/text_column.dart';
import 'package:fluent_orm/schema_builder/column_types/time_column.dart';
import 'package:fluent_orm/schema_builder/column_types/timestamp_column.dart';
import 'package:fluent_orm/schema_builder/column_types/uuid_column.dart';

class AlterTable extends AbstractTable {
  final List<ColumnModifier> actions = [];

  StringColumnContract string (String columnName, { int length = 255 }) {
    final column = StringColumn(this, columnName, length, isAlter: true);
    columnStructure.add(column);

    return column;
  }

  UuidColumnContract uuid (String columnName, { int length = 255 }) {
    final column = UuidColumn(this, columnName, length, isAlter: true);
    columnStructure.add(column);

    return column;
  }

  TextColumnContract text (String columnName) {
    final column = TextColumn(this, columnName, isAlter: true);
    columnStructure.add(column);

    return column;
  }

  IntegerColumnContract integer (String columnName) {
    final column = IntegerColumn(this, columnName, isAlter: true);
    columnStructure.add(column);

    return column;
  }

  BoolColumnContract boolean (String columnName) {
    final column = BoolColumn(columnName, isAlter: true);
    columnStructure.add(column);

    return column;
  }

  IncrementsColumn increments (String columnName) {
    final column = IncrementsColumn(columnName, isAlter: true);
    columnStructure.add(column);

    return column;
  }

  TimestampColumnContract timestamp (String columnName) {
    final column = TimestampColumn(columnName, isAlter: true)
      ..modifiers.add(DefaultToModifier('(now() at time zone \'utc\')'));

    columnStructure.add(column);

    return column;
  }

  DateColumnContract date (String columnName) {
    final column = DateColumn(columnName, isAlter: true);
    columnStructure.add(column);

    return column;
  }

  DateTimeColumnContract dateTime (String columnName) {
    final column = DateTimeColumn(columnName, isAlter: true);
    columnStructure.add(column);

    return column;
  }

  void renameColumn (String oldName, String newName) {
    actions.add(RenameColumnModifier(oldName, newName));
  }

  void dropColumn (String columnName) {
    actions.add(DropColumnModifier(columnName));
  }

  void dropColumns (List<String> columnNames) {
    for (final columnName in columnNames) {
      dropColumn(columnName);
    }
  }

  void dropContraint (String constraintName) {
    actions.add(DropContraintModifier(constraintName));
  }
}