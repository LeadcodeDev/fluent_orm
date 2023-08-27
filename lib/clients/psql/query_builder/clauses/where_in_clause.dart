import 'package:fluent_orm/clients/common/clause.dart';

class WhereInClause extends Clause {
  final String column;
  final List values;

  WhereInClause(this.column, this.values): super('WHERE');

  @override
  String get query => '$token $column IN (${values.join(',')})';
}