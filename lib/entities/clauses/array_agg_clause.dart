import 'package:fluent_orm/entities/clause.dart';
import 'package:fluent_orm/entities/clause_token.dart';
import 'package:fluent_orm/entities/clauses/concat_clause.dart';

class ArrayAggClause extends Clause {
  static final separator = ',\'|\',';
  final List<String> elements;

  ArrayAggClause(this.elements): super(ClauseToken.arrayAgg);

  @override
  String get query {
    final concat = ConcatClause(elements, ArrayAggClause.separator).query;
    return '${token.uid}($concat)';
  }
}