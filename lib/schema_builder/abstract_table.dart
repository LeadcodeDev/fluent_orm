import 'package:fluent_orm/schema_builder/column_modifier.dart';
import 'package:fluent_orm/schema_builder/column_modifiers/primary_modifier.dart';
import 'package:fluent_orm/schema_builder/column_structure.dart';

abstract class AbstractTable {
  final List<ColumnStructure> columnStructure = [];
  final List<PrimaryModifier> primaryKeys = [];
  final List<ColumnModifier> constraints = [];
}