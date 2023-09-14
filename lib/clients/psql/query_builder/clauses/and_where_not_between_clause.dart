import 'package:fluent_orm/clients/common/clause.dart';

class AndWhereNotBetweenClause extends Clause {
  final String column;
  final dynamic start;
  final dynamic end;

  AndWhereNotBetweenClause(this.column, this.start, this.end): super('AND');

  @override
  String get query => '$token $column NOT BETWEEN $start AND $end';
}