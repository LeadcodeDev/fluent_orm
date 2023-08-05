import 'package:fluent_orm/schema_builder/column_modifiers/default_to_modifier.dart';
import 'package:fluent_orm/schema_builder/column_modifiers/not_nullable_modifier.dart';
import 'package:fluent_orm/schema_builder/column_modifiers/nullable_modifier.dart';
import 'package:fluent_orm/schema_builder/column_modifiers/primary_modifier.dart';
import 'package:fluent_orm/schema_builder/column_structure.dart';
import 'package:fluent_orm/schema_builder/table.dart';

abstract interface class TextColumnContract {
  TextColumnContract notNullable();
  TextColumnContract nullable();
  TextColumnContract defaultTo(dynamic value);
}

final class TextColumn extends ColumnStructure implements TextColumnContract {
  final String _columnName;

  TextColumn(this._columnName): super('TEXT');

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
    modifiers.add(DefaultToModifier(value));
    return this;
  }

  @override
  String get query {
    final instructions = [_columnName, token, super.query];
    return instructions.join(' ');
  }
}