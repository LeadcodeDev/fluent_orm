import 'package:fluent_orm/entities/clause.dart';
import 'package:fluent_orm/entities/clause_token.dart';

class AsClause extends Clause {
  final String value;

  AsClause(this.value): super(ClauseToken.as);

  @override
  String get query => '${token.uid} $value';
}