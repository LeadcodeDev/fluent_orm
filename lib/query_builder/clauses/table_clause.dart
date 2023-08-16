import 'package:fluent_orm/query_builder/clause.dart';
import 'package:fluent_orm/query_builder/clause_token.dart';
import 'package:fluent_orm/query_builder/clauses/values_clause.dart';

class TableClause extends Clause {
  final String tableName;

  TableClause(this.tableName): super(ClauseToken.empty);

  @override
  String get query => tableName;
}