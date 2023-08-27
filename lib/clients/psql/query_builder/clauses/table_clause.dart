import 'package:fluent_orm/clients/common/clause.dart';

class TableClause extends Clause {
  final String tableName;

  TableClause(this.tableName): super('');

  @override
  String get query => tableName;
}