import 'package:fluent_orm/schema_builder/column_modifier.dart';

final class NullableModifier extends ColumnModifier {
  NullableModifier(): super('NULL');

  @override
  String get query => token;
}