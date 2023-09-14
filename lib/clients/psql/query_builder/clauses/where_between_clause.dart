import 'package:fluent_orm/clients/common/clause.dart';

class WhereBetweenClause extends Clause {
  final String column;
  final dynamic start;
  final dynamic end;

  WhereBetweenClause(this.column, this.start, this.end): super('WHERE');

  @override
  String get query => '$token $column BETWEEN $start AND $end';
}