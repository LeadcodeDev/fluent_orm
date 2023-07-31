import 'package:fluent_orm/entities/clause_token.dart';
import 'package:fluent_orm/entities/clauses/where_clause.dart';

class OrWhereClause extends WhereClause {
  OrWhereClause(super.column, super.operator, super.value): super(clauseToken: ClauseToken.orWhere);
}