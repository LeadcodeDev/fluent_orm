import 'package:fluent_orm/query_builder/clause.dart';
import 'package:fluent_orm/query_builder/clause_token.dart';

class AsClause extends Clause {
  final String value;

  AsClause(this.value): super(ClauseToken.as);

  @override
  String get query => '${token.uid} $value';
}