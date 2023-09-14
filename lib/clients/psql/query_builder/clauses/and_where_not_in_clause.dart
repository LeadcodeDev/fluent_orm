import 'package:fluent_orm/clients/common/clause.dart';

class AndWhereNotInClause extends Clause {
  final String column;
  final List values;

  AndWhereNotInClause(this.column, this.values): super('AND');

  @override
  String get query => '$token $column NOT IN (${values.join(',')})';
}