import 'package:fluent_orm/clients/common/clause.dart';
import 'package:fluent_orm/clients/psql/query_builder/clauses/concat_clause.dart';

class ArrayAggClause extends Clause {
  static final separator = ',\'|\',';
  final List<String> elements;

  ArrayAggClause(this.elements): super('ARRAY_AGG');

  @override
  String get query {
    final concat = ConcatClause(elements, ArrayAggClause.separator).query;
    return '$token($concat)';
  }
}