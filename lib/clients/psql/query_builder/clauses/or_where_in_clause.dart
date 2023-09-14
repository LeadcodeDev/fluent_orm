import 'package:fluent_orm/clients/common/clause.dart';

class OrWhereInClause extends Clause {
  final String column;
  final List values;

  OrWhereInClause(this.column, this.values): super('OR');

  @override
  String get query => '$token $column IN (${values.join(',')})';
}