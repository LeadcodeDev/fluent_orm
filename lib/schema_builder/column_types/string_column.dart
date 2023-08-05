import 'package:fluent_orm/schema_builder/column_modifiers/default_to_modifier.dart';
import 'package:fluent_orm/schema_builder/column_modifiers/not_nullable_modifier.dart';
import 'package:fluent_orm/schema_builder/column_modifiers/nullable_modifier.dart';
import 'package:fluent_orm/schema_builder/column_modifiers/primary_modifier.dart';
import 'package:fluent_orm/schema_builder/column_modifiers/unique_modifier.dart';
import 'package:fluent_orm/schema_builder/column_structure.dart';
import 'package:fluent_orm/schema_builder/table.dart';

abstract interface class StringColumnContract {
  StringColumnContract notNullable();
  StringColumnContract nullable();
  StringColumnContract defaultTo(dynamic value);
  StringColumnContract primary();
  StringColumnContract unique ({ String? column });
}

final class StringColumn extends ColumnStructure implements StringColumnContract {
  final Table _table;
  final String _columnName;
  final int _length;

  StringColumn(this._table, this._columnName, this._length): super('VARCHAR');

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
    modifiers.add(DefaultToModifier(value));
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
    final instructions = [_columnName, '$token($_length)', super.query];
    return instructions.join(' ');
  }
}