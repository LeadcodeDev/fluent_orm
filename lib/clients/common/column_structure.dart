import 'package:fluent_orm/clients/common/column_modifier.dart';

abstract class ColumnStructure {
  final List<ColumnModifier> modifiers = [];
  final String token;

  ColumnStructure(this.token);

  String get query => modifiers.map((e) => e.query).join(' ');
}