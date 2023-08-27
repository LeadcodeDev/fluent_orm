import 'package:fluent_orm/clients/common/clause.dart';

class OrWhereClause extends Clause {
  final String column;
  final String operator;
  final dynamic value;

  OrWhereClause(this.column, this.operator, this.value): super('OR');

  @override
  String get query => '$token $column $operator \'$value\'';
}