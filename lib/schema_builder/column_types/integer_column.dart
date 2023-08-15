import 'package:fluent_orm/schema_builder/abstract_table.dart';
import 'package:fluent_orm/schema_builder/column_modifiers/default_to_modifier.dart';
import 'package:fluent_orm/schema_builder/column_modifiers/not_nullable_modifier.dart';
import 'package:fluent_orm/schema_builder/column_modifiers/nullable_modifier.dart';
import 'package:fluent_orm/schema_builder/column_modifiers/primary_modifier.dart';
import 'package:fluent_orm/schema_builder/column_modifiers/reference_modifier.dart';
import 'package:fluent_orm/schema_builder/column_modifiers/unique_modifier.dart';
import 'package:fluent_orm/schema_builder/column_structure.dart';

abstract interface class IntegerColumnContract {
  IntegerColumnContract primary();
  IntegerColumnContract notNullable();
  IntegerColumnContract nullable();
  IntegerColumnContract defaultTo(int value);
  IntegerColumnContract unique({ String? column });
  ReferenceModifier reference({ required String column, required String table });
}

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