import 'package:fluent_orm/clients/common/clause.dart';

class AndWhereClause extends Clause {
  final String column;
  final String operator;
  final dynamic value;

  AndWhereClause(this.column, this.operator, this.value): super('AND');

  @override
  String get query => '$token $column $operator \'$value\'';
}