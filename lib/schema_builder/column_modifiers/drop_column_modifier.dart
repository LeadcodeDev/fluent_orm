import 'package:fluent_orm/schema_builder/column_modifier.dart';

class DropColumnModifier extends ColumnModifier {
  final String _columnName;

  DropColumnModifier(this._columnName): super('DROP COLUMN');

  @override
  String get query => [token, _columnName, 'RESTRICT'].join(' ');
}