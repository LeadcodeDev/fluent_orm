import 'package:fluent_orm/schema_builder/column_modifier.dart';

class AutoIncrementModifier extends ColumnModifier {
  AutoIncrementModifier(): super('AUTO_INCREMENT');

  @override
  String get query => token;
}