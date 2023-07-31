import 'package:fluent_orm/entities/clause.dart';
import 'package:fluent_orm/entities/clause_operator.dart';
import 'package:fluent_orm/entities/clause_token.dart';

class WhereClause extends Clause {
  final String column;
  final ClauseOperator operator;
  final dynamic value;

  WhereClause(this.column, this.operator, this.value, { ClauseToken? clauseToken }): super(clauseToken ?? ClauseToken.where);

  @override
  String get query {
    final String operator = this.operator.uid;
    final String value = '${this.value}';

    return '${token.uid} $column $operator $value';
  }
}