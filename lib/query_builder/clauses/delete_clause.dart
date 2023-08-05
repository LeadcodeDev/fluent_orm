import 'package:fluent_orm/query_builder/clause.dart';
import 'package:fluent_orm/query_builder/clause_token.dart';

class DeleteClause extends Clause {
  DeleteClause(): super(ClauseToken.delete);
}