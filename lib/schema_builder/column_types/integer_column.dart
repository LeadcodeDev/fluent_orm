import 'package:fluent_orm/schema_builder/column_modifiers/auto_increment_modifier.dart';
import 'package:fluent_orm/schema_builder/column_modifiers/default_to_modifier.dart';
import 'package:fluent_orm/schema_builder/column_modifiers/not_nullable_modifier.dart';
import 'package:fluent_orm/schema_builder/column_modifiers/nullable_modifier.dart';
import 'package:fluent_orm/schema_builder/column_modifiers/primary_modifier.dart';
import 'package:fluent_orm/schema_builder/column_structure.dart';
import 'package:fluent_orm/schema_builder/table.dart';

abstract interface class IntegerColumnContract {
  IntegerColumnContract primary();
  IntegerColumnContract notNullable();
  IntegerColumnContract nullable();
  IntegerColumnContract defaultTo(int value);
}

final class IntegerColumn extends ColumnStructure implements IntegerColumnContract {
  final Table _table;
  final String _columnName;

  IntegerColumn(this._table, this._columnName): super('INTEGER');


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
  String get query {
    final instructions = [_columnName, [token, super.query].join(' ')];
    return instructions.join(' ');
  }
}