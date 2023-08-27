import 'package:fluent_orm/clients/common/abstract_column_type.dart';
import 'package:fluent_orm/clients/common/abstract_create_table.dart';
import 'package:fluent_orm/clients/psql/schema/abstract_psql_table.dart';
import 'package:fluent_orm/clients/psql/schema/column_modifiers/default_to_modifier.dart';
import 'package:fluent_orm/clients/psql/schema/column_types/bool_column.dart';
import 'package:fluent_orm/clients/psql/schema/column_types/date_column.dart';
import 'package:fluent_orm/clients/psql/schema/column_types/increments_column.dart';
import 'package:fluent_orm/clients/psql/schema/column_types/integer_column.dart';
import 'package:fluent_orm/clients/psql/schema/column_types/string_column.dart';
import 'package:fluent_orm/clients/psql/schema/column_types/text_column.dart';
import 'package:fluent_orm/clients/psql/schema/column_types/time_column.dart';
import 'package:fluent_orm/clients/psql/schema/column_types/timestamp_column.dart';
import 'package:fluent_orm/clients/psql/schema/column_types/uuid_column.dart';

class PsqlCreateTable extends AbstractPsqlTable implements AbstractCreateTable {
  @override
  StringColumnContract string (String columnName, { int length = 255 }) {
    final column = StringColumn(this, columnName, length);
    columnStructure.add(column);

    return column;
  }

  @override
  UuidColumnContract uuid (String columnName, { int length = 255 }) {
    final column = UuidColumn(this, columnName);
    columnStructure.add(column);

    return column;
  }

  @override
  TextColumnContract text (String columnName) {
    final column = TextColumn(this, columnName);
    columnStructure.add(column);

    return column;
  }

  @override
  IntegerColumnContract integer (String columnName) {
    final column = IntegerColumn(this, columnName);
    columnStructure.add(column);

    return column;
  }

  @override
  BoolColumnContract boolean (String columnName) {
    final column = BoolColumn(columnName);
    columnStructure.add(column);

    return column;
  }

  @override
  IncrementsColumn increments (String columnName) {
    final column = IncrementsColumn(columnName);
    columnStructure.add(column);

    return column;
  }

  @override
  TimestampColumnContract timestamp (String columnName) {
    final column = TimestampColumn(columnName)
      ..modifiers.add(DefaultToModifier('(now() at time zone \'utc\')'));

    columnStructure.add(column);

    return column;
  }

  @override
  DateColumnContract date (String columnName) {
    final column = DateColumn(columnName);
    columnStructure.add(column);

    return column;
  }

  @override
  DateTimeColumnContract dateTime (String columnName) {
    final column = DateTimeColumn(columnName);
    columnStructure.add(column);

    return column;
  }
}