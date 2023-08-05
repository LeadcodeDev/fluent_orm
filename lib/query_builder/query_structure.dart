import 'package:fluent_orm/entities/model_wrapper.dart';
import 'package:fluent_orm/query_builder/structures/clause_structure.dart';

final class QueryStructure {
  late ModelWrapper model;
  final ClauseStructure clauses = ClauseStructure();
  // final List<PreloadRelation> preloads = [];
}