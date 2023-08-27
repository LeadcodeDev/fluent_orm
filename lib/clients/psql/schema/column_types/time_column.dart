import 'package:fluent_orm/clients/common/abstract_column_type.dart';
import 'package:fluent_orm/clients/psql/schema/column_modifiers/not_nullable_modifier.dart';
import 'package:fluent_orm/clients/psql/schema/column_modifiers/nullable_modifier.dart';
import 'package:fluent_orm/clients/common/column_structure.dart';

final class DateTimeColumn extends ColumnStructure implements DateTimeColumnContract {
  final String _columnName;
  final bool isAlter;

  DateTimeColumn(this._columnName, { this.isAlter = false }): super('TIME');

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
    final instructions = [isAlter ? 'ADD COLUMN' : null, _columnName, token, super.query];
    return instructions.nonNulls.join(' ');
  }
}