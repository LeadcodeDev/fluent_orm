import 'package:fluent_orm/schema_builder/column_modifiers/default_to_modifier.dart';
import 'package:fluent_orm/schema_builder/column_modifiers/not_nullable_modifier.dart';
import 'package:fluent_orm/schema_builder/column_modifiers/nullable_modifier.dart';
import 'package:fluent_orm/schema_builder/column_structure.dart';

abstract interface class BoolColumnContract {
  BoolColumnContract notNullable();
  BoolColumnContract nullable();
  BoolColumnContract defaultTo(bool value);
}

final class BoolColumn extends ColumnStructure implements BoolColumnContract {
  final String _columnName;

  BoolColumn(this._columnName): super('BOOLEAN');

  @override
  BoolColumnContract nullable() {
    modifiers.add(NullableModifier());
    return this;
  }

  @override
  BoolColumnContract notNullable() {
    modifiers.add(NotNullableModifier());
    return this;
  }

  @override
  BoolColumnContract defaultTo(final bool value) {
    modifiers.add(DefaultToModifier(value));
    return this;
  }

  @override
  String get query {
    final instructions = [_columnName, token, super.query];
    return instructions.join(' ');
  }
}