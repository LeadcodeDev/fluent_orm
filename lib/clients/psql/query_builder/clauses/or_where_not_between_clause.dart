import 'package:fluent_orm/clients/common/clause.dart';

class OrWhereNotBetweenClause extends Clause {
  final String column;
  final dynamic start;
  final dynamic end;

  OrWhereNotBetweenClause(this.column, this.start, this.end): super('OR');

  @override
  String get query => '$token $column NOT BETWEEN $start AND $end';
}