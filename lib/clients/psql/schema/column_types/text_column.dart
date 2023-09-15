import 'package:fluent_orm/clients/common/abstract_column_type.dart';
import 'package:fluent_orm/clients/psql/schema/abstract_psql_table.dart';
import 'package:fluent_orm/clients/psql/schema/column_modifiers/default_to_modifier.dart';
import 'package:fluent_orm/clients/psql/schema/column_modifiers/not_nullable_modifier.dart';
import 'package:fluent_orm/clients/psql/schema/column_modifiers/nullable_modifier.dart';
import 'package:fluent_orm/clients/psql/schema/column_modifiers/unique_modifier.dart';
import 'package:fluent_orm/clients/common/column_structure.dart';

final class TextColumn extends ColumnStructure implements TextColumnContract {
  final AbstractPsqlTable _table;
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