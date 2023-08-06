import 'package:fluent_orm/schema_builder/column_modifiers/default_to_modifier.dart';
import 'package:fluent_orm/schema_builder/column_modifiers/not_nullable_modifier.dart';
import 'package:fluent_orm/schema_builder/column_modifiers/nullable_modifier.dart';
import 'package:fluent_orm/schema_builder/column_modifiers/primary_modifier.dart';
import 'package:fluent_orm/schema_builder/column_modifiers/unique_modifier.dart';
import 'package:fluent_orm/schema_builder/column_structure.dart';
import 'package:fluent_orm/schema_builder/table.dart';

abstract interface class UuidColumnContract {
  UuidColumnContract notNullable();
  UuidColumnContract nullable();
  UuidColumnContract defaultTo(dynamic value);
  UuidColumnContract primary();
  UuidColumnContract unique ({ String? column });
}

final class UuidColumn extends ColumnStructure implements UuidColumnContract {
  final Table _table;
  final String _columnName;
  final int _length;

  UuidColumn(this._table, this._columnName, this._length): super('UUID');

  @override
  UuidColumnContract nullable() {
    modifiers.add(NullableModifier());
    return this;
  }

  @override
  UuidColumnContract notNullable() {
    modifiers.add(NotNullableModifier());
    return this;
  }

  @override
  UuidColumnContract defaultTo(final value) {
    modifiers.add(DefaultToModifier(value));
    return this;
  }

  @override
  UuidColumnContract primary() {
    _table.primaryKeys.add(PrimaryModifier(_columnName));
    return this;
  }

  @override
  UuidColumnContract unique ({ String? column }) {
    _table.constraints.add(UniqueModifier(column ?? _columnName));
    return this;
  }

  @override
  String get query {
    final instructions = [_columnName, token, super.query];
    return instructions.join(' ');
  }
}