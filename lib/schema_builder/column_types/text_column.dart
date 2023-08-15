import 'package:fluent_orm/schema_builder/abstract_table.dart';
import 'package:fluent_orm/schema_builder/column_modifiers/default_to_modifier.dart';
import 'package:fluent_orm/schema_builder/column_modifiers/not_nullable_modifier.dart';
import 'package:fluent_orm/schema_builder/column_modifiers/nullable_modifier.dart';
import 'package:fluent_orm/schema_builder/column_modifiers/unique_modifier.dart';
import 'package:fluent_orm/schema_builder/column_structure.dart';

abstract interface class TextColumnContract {
  TextColumnContract notNullable();
  TextColumnContract nullable();
  TextColumnContract defaultTo(dynamic value);
  TextColumnContract unique ({ String? column });
}

final class TextColumn extends ColumnStructure implements TextColumnContract {
  final AbstractTable _table;
  final String _columnName;
  final bool isAlter;

  TextColumn(this._table, this._columnName, { this.isAlter = false }): super('TEXT');

  @override
  TextColumnContract nullable() {
    modifiers.add(NullableModifier());
    return this;
  }

  @override
  TextColumnContract notNullable() {
    modifiers.add(NotNullableModifier());
    return this;
  }

  @override
  TextColumnContract defaultTo(final value) {
    modifiers.add(DefaultToModifier('\'$value\''));
    return this;
  }

  @override
  TextColumnContract unique ({ String? column }) {
    _table.constraints.add(UniqueModifier(column ?? _columnName));
    return this;
  }

  @override
  String get query {
    final instructions = [isAlter ? 'ADD COLUMN' : null, _columnName, token, super.query];
    return instructions.nonNulls.join(' ');
  }
}