import 'package:fluent_orm/schema_builder/column_modifier.dart';

class RenameColumnModifier extends ColumnModifier {
  final String _oldColumnName;
  final String _newColumnName;

  RenameColumnModifier(this._oldColumnName, this._newColumnName): super('RENAME COLUMN');

  @override
  String get query => [token, _oldColumnName, 'TO', _newColumnName].join(' ');
}