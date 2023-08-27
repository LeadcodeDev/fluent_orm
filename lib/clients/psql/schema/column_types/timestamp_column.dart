import 'package:fluent_orm/clients/common/abstract_column_type.dart';
import 'package:fluent_orm/clients/psql/schema/column_modifiers/not_nullable_modifier.dart';
import 'package:fluent_orm/clients/psql/schema/column_modifiers/nullable_modifier.dart';
import 'package:fluent_orm/clients/common/column_structure.dart';

final class TimestampColumn extends ColumnStructure implements TimestampColumnContract {
  final String _columnName;
  final bool isAlter;

  TimestampColumn(this._columnName, { bool time = true, this.isAlter = false }): super('TIMESTAMP ${time ? 'WITH TIME ZONE' : ''}');

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
    final instructions = [isAlter ? 'ADD COLUMN' : null, _columnName, token, super.query];
    return instructions.nonNulls.join(' ');
  }
}