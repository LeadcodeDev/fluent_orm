import 'package:fluent_orm/clients/common/column_modifier.dart';

class PrimaryModifier extends ColumnModifier {
  final String columnName;

  PrimaryModifier(this.columnName): super('PRIMARY KEY');

  @override
  String get query => '$token ($columnName)';
}