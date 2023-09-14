import 'package:fluent_orm/clients/common/clause.dart';

class OrWhereBetweenClause extends Clause {
  final String column;
  final dynamic start;
  final dynamic end;

  OrWhereBetweenClause(this.column, this.start, this.end): super('Or');

  @override
  String get query => '$token $column BETWEEN $start AND $end';
}