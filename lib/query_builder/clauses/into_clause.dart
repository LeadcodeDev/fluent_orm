import 'package:fluent_orm/query_builder/clause.dart';
import 'package:fluent_orm/query_builder/clause_token.dart';

class IntoClause extends Clause {
  final String tableName;

  IntoClause(this.tableName): super(ClauseToken.into);

  @override
  String get query {
    final instructions = [token.uid, tableName];
    return instructions.join(' ');
  }
}