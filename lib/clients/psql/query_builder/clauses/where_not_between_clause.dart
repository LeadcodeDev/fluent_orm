import 'package:fluent_orm/clients/common/clause.dart';

class WhereNotBetweenClause extends Clause {
  final String column;
  final dynamic start;
  final dynamic end;

  WhereNotBetweenClause(this.column, this.start, this.end): super('WHERE');

  @override
  String get query => '$token $column NOT BETWEEN $start AND $end';
}