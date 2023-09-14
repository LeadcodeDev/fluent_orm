import 'package:fluent_orm/clients/common/clause.dart';

class AndWhereInClause extends Clause {
  final String column;
  final List values;

  AndWhereInClause(this.column, this.values): super('AND');

  @override
  String get query => '$token $column IN (${values.join(',')})';
}