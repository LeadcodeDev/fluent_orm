import 'package:fluent_orm/clients/common/abstract_column_type.dart';
import 'package:fluent_orm/clients/common/column_structure.dart';

abstract class AbstractCreateTable {
  StringColumnContract string (String columnName, { int length = 255 });
  UuidColumnContract uuid (String columnName, { int length = 255 });
  TextColumnContract text (String columnName);
  IntegerColumnContract integer (String columnName);
  BoolColumnContract boolean (String columnName);
  ColumnStructure increments (String columnName);
  TimestampColumnContract timestamp (String columnName);
  DateColumnContract date (String columnName);
  DateTimeColumnContract dateTime (String columnName);
}