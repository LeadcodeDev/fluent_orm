import 'package:fluent_orm/clients/common/abstract_column_type.dart';
import 'package:fluent_orm/clients/psql/schema/abstract_table.dart';
import 'package:fluent_orm/clients/psql/schema/column_modifiers/default_to_modifier.dart';
import 'package:fluent_orm/clients/psql/schema/column_modifiers/not_nullable_modifier.dart';
import 'package:fluent_orm/clients/psql/schema/column_modifiers/nullable_modifier.dart';
import 'package:fluent_orm/clients/psql/schema/column_modifiers/primary_modifier.dart';
import 'package:fluent_orm/clients/psql/schema/column_modifiers/unique_modifier.dart';
import 'package:fluent_orm/clients/common/column_structure.dart';

final class StringColumn extends ColumnStructure implements StringColumnContract {
  final AbstractTable _table;
  final String _columnName;
  final int _length;
  final bool isAlter;

  StringColumn(this._table, this._columnName, this._length, { this.isAlter = false }): super('VARCHAR');

  @override
  StringColumnContract nullable() {
    modifiers.add(NullableModifier());
    return this;
  }

  @override
  StringColumnContract notNullable() {
    modifiers.add(NotNullableModifier());
    return this;
  }

  @override
  StringColumnContract defaultTo(final value) {
    modifiers.add(DefaultToModifier('\'$value\''));
    return this;
  }

  @override
  StringColumnContract primary() {
    _table.primaryKeys.add(PrimaryModifier(_columnName));
    return this;
  }

  @override
  StringColumnContract unique ({ String? column }) {
    _table.constraints.add(UniqueModifier(column ?? _columnName));
    return this;
  }

  @override
  String get query {
    final instructions = [isAlter ? 'ADD COLUMN' : null, _columnName, '$token($_length)', super.query];
    return instructions.nonNulls.join(' ');
  }
}