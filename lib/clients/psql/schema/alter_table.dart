import 'package:fluent_orm/clients/common/abstract_alter_table.dart';
import 'package:fluent_orm/clients/common/abstract_column_type.dart';
import 'package:fluent_orm/clients/psql/schema/abstract_table.dart';
import 'package:fluent_orm/clients/common/column_modifier.dart';
import 'package:fluent_orm/clients/psql/schema/column_modifiers/default_to_modifier.dart';
import 'package:fluent_orm/clients/psql/schema/column_modifiers/drop_column_modifier.dart';
import 'package:fluent_orm/clients/psql/schema/column_modifiers/drop_contraint_modifier.dart';
import 'package:fluent_orm/clients/psql/schema/column_modifiers/rename_column_modifier.dart';
import 'package:fluent_orm/clients/psql/schema/column_types/bool_column.dart';
import 'package:fluent_orm/clients/psql/schema/column_types/date_column.dart';
import 'package:fluent_orm/clients/psql/schema/column_types/increments_column.dart';
import 'package:fluent_orm/clients/psql/schema/column_types/integer_column.dart';
import 'package:fluent_orm/clients/psql/schema/column_types/string_column.dart';
import 'package:fluent_orm/clients/psql/schema/column_types/text_column.dart';
import 'package:fluent_orm/clients/psql/schema/column_types/time_column.dart';
import 'package:fluent_orm/clients/psql/schema/column_types/timestamp_column.dart';
import 'package:fluent_orm/clients/psql/schema/column_types/uuid_column.dart';

class AlterTable extends AbstractTable implements AbstractAlterTable {
  final List<ColumnModifier> actions = [];

  @override
  StringColumnContract string (String columnName, { int length = 255 }) {
    final column = StringColumn(this, columnName, length, isAlter: true);
    columnStructure.add(column);

    return column;
  }

  @override
  UuidColumnContract uuid (String columnName) {
    final column = UuidColumn(this, columnName, isAlter: true);
    columnStructure.add(column);

    return column;
  }

  @override
  TextColumnContract text (String columnName) {
    final column = TextColumn(this, columnName, isAlter: true);
    columnStructure.add(column);

    return column;
  }

  @override
  IntegerColumnContract integer (String columnName) {
    final column = IntegerColumn(this, columnName, isAlter: true);
    columnStructure.add(column);

    return column;
  }

  @override
  BoolColumnContract boolean (String columnName) {
    final column = BoolColumn(columnName, isAlter: true);
    columnStructure.add(column);

    return column;
  }

  @override
  IncrementsColumn increments (String columnName) {
    final column = IncrementsColumn(columnName, isAlter: true);
    columnStructure.add(column);

    return column;
  }

  @override
  TimestampColumnContract timestamp (String columnName) {
    final column = TimestampColumn(columnName, isAlter: true)
      ..modifiers.add(DefaultToModifier('(now() at time zone \'utc\')'));

    columnStructure.add(column);

    return column;
  }

  @override
  DateColumnContract date (String columnName) {
    final column = DateColumn(columnName, isAlter: true);
    columnStructure.add(column);

    return column;
  }

  @override
  DateTimeColumnContract dateTime (String columnName) {
    final column = DateTimeColumn(columnName, isAlter: true);
    columnStructure.add(column);

    return column;
  }

  @override
  void renameColumn (String oldName, String newName) {
    actions.add(RenameColumnModifier(oldName, newName));
  }

  @override
  void dropColumn (String columnName) {
    actions.add(DropColumnModifier(columnName));
  }

  @override
  void dropColumns (List<String> columnNames) {
    for (final columnName in columnNames) {
      dropColumn(columnName);
    }
  }

  @override
  void dropContraint (String constraintName) {
    actions.add(DropContraintModifier(constraintName));
  }
}