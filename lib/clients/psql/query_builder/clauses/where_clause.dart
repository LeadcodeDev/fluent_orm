import 'package:fluent_orm/clients/common/clause.dart';

class WhereClause extends Clause {
  final String column;
  final String operator;
  final dynamic value;

  WhereClause(this.column, this.operator, this.value): super('WHERE');

  @override
  String get query => '$token $column $operator \'$value\'';
}