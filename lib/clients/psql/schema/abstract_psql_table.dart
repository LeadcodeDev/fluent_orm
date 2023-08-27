import 'package:fluent_orm/clients/common/column_modifier.dart';
import 'package:fluent_orm/clients/psql/schema/column_modifiers/primary_modifier.dart';
import 'package:fluent_orm/clients/common/column_structure.dart';

abstract class AbstractPsqlTable {
  final List<ColumnStructure> columnStructure = [];
  final List<PrimaryModifier> primaryKeys = [];
  final List<ColumnModifier> constraints = [];
}