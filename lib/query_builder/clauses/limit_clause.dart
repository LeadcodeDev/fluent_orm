import 'package:fluent_orm/query_builder/clause.dart';
import 'package:fluent_orm/query_builder/clause_token.dart';

class LimitClause extends Clause {
  final int value;

  LimitClause(this.value): super(ClauseToken.limit);

  @override
  String get query => '${token.uid} $value';
}