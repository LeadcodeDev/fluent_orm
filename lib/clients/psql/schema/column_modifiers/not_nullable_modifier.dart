import 'package:fluent_orm/clients/common/column_modifier.dart';

final class NotNullableModifier extends ColumnModifier {
  NotNullableModifier(): super('NOT NULL');

  @override
  String get query => token;
}