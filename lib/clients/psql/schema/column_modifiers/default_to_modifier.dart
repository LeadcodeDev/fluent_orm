import 'package:fluent_orm/clients/common/column_modifier.dart';

class DefaultToModifier extends ColumnModifier {
  final dynamic value;

  DefaultToModifier(this.value): super('DEFAULT');

  @override
  String get query => "$token $value";
}