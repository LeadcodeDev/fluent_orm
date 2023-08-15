import 'package:fluent_orm/schema_builder/column_structure.dart';

final class IncrementsColumn extends ColumnStructure {
  final String _columnName;
  final bool isAlter;

  IncrementsColumn(this._columnName, { this.isAlter = false }): super('SERIAL PRIMARY KEY');

  @override
  String get query {
    final instructions = [isAlter ? 'ADD COLUMN' : null, _columnName, token];
    return instructions.nonNulls.join(' ');
  }
}