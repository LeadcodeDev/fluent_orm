import 'package:fluent_orm/clients/common/abstract_clause_structure.dart';
import 'package:fluent_orm/clients/common/model_wrapper.dart';
import 'package:fluent_orm/clients/common/preloaded_relation.dart';

final class QueryStructure<T extends AbstractClauseStructure> {
  late ModelWrapper model;
  final T clauses;
  final List<PreloadRelation> preloads = [];

  QueryStructure(this.clauses);
}