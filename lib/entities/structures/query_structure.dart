import 'package:fluent_orm/entities/model_wrapper.dart';
import 'package:fluent_orm/entities/structures/clause_structure.dart';

class QueryStructure {
  ModelWrapper model;
  final ClauseStructure clauses = ClauseStructure();
  // final List<PreloadRelation> preloads = [];

  QueryStructure(this.model);
}