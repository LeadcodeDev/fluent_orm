import 'package:fluent_orm/query_builder/clause.dart';
import 'package:fluent_orm/query_builder/clause_token.dart';

class DeleteClause extends Clause {
  final String tableName;

  DeleteClause(this.tableName): super(ClauseToken.delete);

  @override
  String get query {
    final instructions = [token.uid, 'FROM', tableName];
    return instructions.join(' ');
  }
}