import 'package:fluent_orm/schema_builder/column_structure.dart';

final class IncrementsColumn extends ColumnStructure {
  final String _columnName;

  IncrementsColumn(this._columnName): super('SERIAL PRIMARY KEY');

  @override
  String get query {
    final instructions = [_columnName, token];
    return instructions.join(' ');
  }
}