import 'package:fluent_orm/clients/common/column_modifier.dart';

class AutoIncrementModifier extends ColumnModifier {
  AutoIncrementModifier(): super('AUTO_INCREMENT');

  @override
  String get query => token;
}