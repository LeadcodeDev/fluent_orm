import 'package:fluent_orm/query_builder/clause.dart';
import 'package:fluent_orm/query_builder/clause_token.dart';

class ReturningClause extends Clause {
  final String value;

  ReturningClause(this.value): super(ClauseToken.returning);

  @override
  String get query => '${token.uid} $value';
}