import 'package:fluent_orm/clients/common/clause.dart';

class AndWhereBetweenClause extends Clause {
  final String column;
  final dynamic start;
  final dynamic end;

  AndWhereBetweenClause(this.column, this.start, this.end): super('AND');

  @override
  String get query => '$token $column BETWEEN $start AND $end';
}