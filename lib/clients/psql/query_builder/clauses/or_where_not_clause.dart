import 'package:fluent_orm/clients/common/clause.dart';

class OrWhereNotClause extends Clause {
  final String column;
  final dynamic value;

  OrWhereNotClause(this.column, this.value): super('OR');

  @override
  String get query => '$token $column NOT $value';
}