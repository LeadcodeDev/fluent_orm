import 'package:fluent_orm/clients/common/column_modifier.dart';

class ReferenceModifier extends ColumnModifier {
  final String _column;
  final String _table;

  ReferenceModifier(this._column, this._table): super('REFERENCES');

  @override
  String get query => ' $token $_table ($_column)';
}