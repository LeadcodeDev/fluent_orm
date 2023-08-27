import 'package:fluent_orm/clients/common/column_modifier.dart';

class DropColumnModifier extends ColumnModifier {
  final String _columnName;

  DropColumnModifier(this._columnName): super('DROP COLUMN');

  @override
  String get query => [token, _columnName, 'RESTRICT'].join(' ');
}