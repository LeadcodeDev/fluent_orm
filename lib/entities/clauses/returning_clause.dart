import 'package:fluent_orm/entities/clause.dart';
import 'package:fluent_orm/entities/clause_token.dart';

class ReturningClause extends Clause {
  final String value;

  ReturningClause(this.value): super(ClauseToken.returning);

  @override
  String get query => '${token.uid} $value';
}