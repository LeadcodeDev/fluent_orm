import 'package:fluent_orm/clients/common/clause.dart';

class IntoClause extends Clause {
  final String tableName;

  IntoClause(this.tableName): super('INTO');

  @override
  String get query => '$token $tableName';
}