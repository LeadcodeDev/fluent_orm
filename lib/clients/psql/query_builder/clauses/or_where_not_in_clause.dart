import 'package:fluent_orm/clients/common/clause.dart';

class OrWhereNotInClause extends Clause {
  final String column;
  final List values;

  OrWhereNotInClause(this.column, this.values): super('OR');

  @override
  String get query => '$token $column NOT IN (${values.join(',')})';
}