import 'package:fluent_orm/clients/common/clause.dart';

class WhereNotInClause extends Clause {
  final String column;
  final List values;

  WhereNotInClause(this.column, this.values): super('WHERE');

  @override
  String get query => '$token $column NOT IN (${values.join(',')})';
}