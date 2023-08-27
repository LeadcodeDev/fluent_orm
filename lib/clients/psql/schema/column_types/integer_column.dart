import 'package:fluent_orm/clients/common/abstract_column_type.dart';
import 'package:fluent_orm/clients/psql/schema/abstract_table.dart';
import 'package:fluent_orm/clients/psql/schema/column_modifiers/default_to_modifier.dart';
import 'package:fluent_orm/clients/psql/schema/column_modifiers/not_nullable_modifier.dart';
import 'package:fluent_orm/clients/psql/schema/column_modifiers/nullable_modifier.dart';
import 'package:fluent_orm/clients/psql/schema/column_modifiers/primary_modifier.dart';
import 'package:fluent_orm/clients/psql/schema/column_modifiers/reference_modifier.dart';
import 'package:fluent_orm/clients/psql/schema/column_modifiers/unique_modifier.dart';
import 'package:fluent_orm/clients/common/column_structure.dart';

final class IntegerColumn extends ColumnStructure implements IntegerColumnContract {
  final AbstractTable _table;
  final String _columnName;
  final bool isAlter;

  IntegerColumn(this._table, this._columnName, { this.isAlter = false }): super('INTEGER');


  @override
  IntegerColumnContract primary() {
    _table.primaryKeys.add(PrimaryModifier(_columnName));
    return this;
  }

  @override
  IntegerColumnContract nullable() {
    modifiers.add(NullableModifier());
    return this;
  }

  @override
  IntegerColumnContract notNullable() {
    modifiers.add(NotNullableModifier());
    return this;
  }

  @override
  IntegerColumnContract defaultTo(final int value) {
    modifiers.add(DefaultToModifier(value));
    return this;
  }

  @override
  IntegerColumnContract unique ({ String? column }) {
    _table.constraints.add(UniqueModifier(column ?? _columnName));
    return this;
  }

  @override
  ReferenceModifier reference({ required String column, required String table }) {
    final modifier = ReferenceModifier(column, table);
    modifiers.add(modifier);
    return modifier;
  }

  @override
  String get query {
    final instructions = [isAlter ? 'ADD COLUMN' : null, _columnName, [token, super.query].join(' ')];
    return instructions.nonNulls.join(' ');
  }
}