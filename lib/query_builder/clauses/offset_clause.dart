import 'package:fluent_orm/query_builder/clause.dart';
import 'package:fluent_orm/query_builder/clause_token.dart';

class OffsetClause extends Clause {
  final int value;

  OffsetClause(this.value): super(ClauseToken.offset);

  @override
  String get query => '${token.uid} $value';
}