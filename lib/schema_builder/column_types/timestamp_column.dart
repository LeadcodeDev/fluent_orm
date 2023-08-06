import 'package:fluent_orm/schema_builder/column_modifiers/not_nullable_modifier.dart';
import 'package:fluent_orm/schema_builder/column_modifiers/nullable_modifier.dart';
import 'package:fluent_orm/schema_builder/column_structure.dart';

abstract interface class TimestampColumnContract {
  TimestampColumnContract notNullable();
  TimestampColumnContract nullable();
}

final class TimestampColumn extends ColumnStructure implements TimestampColumnContract {
  final String _columnName;

  TimestampColumn(this._columnName, { bool time = true }): super('TIMESTAMP ${time ? 'WITH TIME ZONE' : ''}');

  @override
  TimestampColumnContract nullable() {
    modifiers.add(NullableModifier());
    return this;
  }

  @override
  TimestampColumnContract notNullable() {
    modifiers.add(NotNullableModifier());
    return this;
  }

  @override
  String get query {
    final instructions = [_columnName, token, super.query];
    return instructions.join(' ');
  }
}