import 'package:fluent_orm/schema_builder/column_modifiers/not_nullable_modifier.dart';
import 'package:fluent_orm/schema_builder/column_modifiers/nullable_modifier.dart';
import 'package:fluent_orm/schema_builder/column_structure.dart';

abstract interface class DateTimeColumnContract {
  DateTimeColumnContract notNullable();
  DateTimeColumnContract nullable();
}

final class DateTimeColumn extends ColumnStructure implements DateTimeColumnContract {
  final String _columnName;

  DateTimeColumn(this._columnName): super('TIME');

  @override
  DateTimeColumnContract nullable() {
    modifiers.add(NullableModifier());
    return this;
  }

  @override
  DateTimeColumnContract notNullable() {
    modifiers.add(NotNullableModifier());
    return this;
  }

  @override
  String get query {
    final instructions = [_columnName, token, super.query];
    return instructions.join(' ');
  }
}