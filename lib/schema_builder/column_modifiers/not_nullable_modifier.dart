import 'package:fluent_orm/schema_builder/column_modifier.dart';

final class NotNullableModifier extends ColumnModifier {
  NotNullableModifier(): super('NOT NULL');

  @override
  String get query => token;
}