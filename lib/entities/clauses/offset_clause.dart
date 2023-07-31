import 'package:fluent_orm/entities/clause.dart';
import 'package:fluent_orm/entities/clause_token.dart';

class OffsetClause extends Clause {
  final int value;

  OffsetClause(this.value): super(ClauseToken.offset);

  @override
  String get query => '${token.uid} $value';
}