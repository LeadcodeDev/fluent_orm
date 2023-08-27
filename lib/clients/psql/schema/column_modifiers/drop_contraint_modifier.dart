import 'package:fluent_orm/clients/common/column_modifier.dart';

class DropContraintModifier extends ColumnModifier {
  final String _contraintName;

  DropContraintModifier(this._contraintName): super('DROP CONSTRAINT');

  @override
  String get query => [token, _contraintName].join(' ');
}