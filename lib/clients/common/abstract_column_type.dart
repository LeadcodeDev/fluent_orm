import 'package:fluent_orm/clients/common/column_modifier.dart';

abstract interface class StringColumnContract {
  StringColumnContract notNullable();
  StringColumnContract nullable();
  StringColumnContract defaultTo(dynamic value);
  StringColumnContract primary();
  StringColumnContract unique ({ String? column });
}

abstract interface class UuidColumnContract {
  UuidColumnContract notNullable();
  UuidColumnContract nullable();
  UuidColumnContract defaultTo(dynamic value);
  UuidColumnContract primary();
  UuidColumnContract unique ({ String? column });
}

abstract interface class TextColumnContract {
  TextColumnContract notNullable();
  TextColumnContract nullable();
  TextColumnContract defaultTo(dynamic value);
  TextColumnContract unique ({ String? column });
}

abstract interface class IntegerColumnContract {
  IntegerColumnContract primary();
  IntegerColumnContract notNullable();
  IntegerColumnContract nullable();
  IntegerColumnContract defaultTo(int value);
  IntegerColumnContract unique({ String? column });
  ColumnModifier reference({ required String column, required String table });
}

abstract interface class BoolColumnContract {
  BoolColumnContract notNullable();
  BoolColumnContract nullable();
  BoolColumnContract defaultTo(bool value);
}

abstract interface class TimestampColumnContract {
  TimestampColumnContract notNullable();
  TimestampColumnContract nullable();
}

abstract interface class DateColumnContract {
  DateColumnContract notNullable();
  DateColumnContract nullable();
}

abstract interface class DateTimeColumnContract {
  DateTimeColumnContract notNullable();
  DateTimeColumnContract nullable();
}