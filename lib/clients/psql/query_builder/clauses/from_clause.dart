import 'package:fluent_orm/clients/common/clause.dart';

class FromClause extends Clause {
  final String tableName;

  FromClause(this.tableName): super('FROM');

  @override
  String get query => '$token $tableName';
}