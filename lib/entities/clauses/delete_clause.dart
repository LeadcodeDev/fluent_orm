import 'package:fluent_orm/entities/clause.dart';
import 'package:fluent_orm/entities/clause_token.dart';

class DeleteClause extends Clause {
  DeleteClause(): super(ClauseToken.delete);
}