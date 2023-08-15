import 'package:fluent_orm/schema_builder/column_modifiers/not_nullable_modifier.dart';
import 'package:fluent_orm/schema_builder/column_modifiers/nullable_modifier.dart';
import 'package:fluent_orm/schema_builder/column_structure.dart';

abstract interface class DateColumnContract {
  DateColumnContract notNullable();
  DateColumnContract nullable();
}

final class DateColumn extends ColumnStructure implements DateColumnContract {
  final String _columnName;
  final bool isAlter;

  DateColumn(this._columnName, { this.isAlter = false }): super('DATE');

  @override
  DateColumnContract nullable() {
    modifiers.add(NullableModifier());
    return this;
  }

  @override
  DateColumnContract notNullable() {
    modifiers.add(NotNullableModifier());
    return this;
  }

  @override
  String get query {
    final instructions = [isAlter ? 'ADD COLUMN' : null, _columnName, token, super.query];
    return instructions.nonNulls.join(' ');
  }
}