import 'package:fluent_orm/query_builder/clause.dart';
import 'package:fluent_orm/query_builder/clause_token.dart';

class FromClause extends Clause {
  final String tableName;

  FromClause(this.tableName): super(ClauseToken.from);

  @override
  String get query => '${token.uid} $tableName';
}