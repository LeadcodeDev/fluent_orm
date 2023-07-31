import 'package:fluent_orm/entities/clause.dart';
import 'package:fluent_orm/entities/clause_token.dart';

class FromClause extends Clause {
  final String tableName;

  FromClause(this.tableName): super(ClauseToken.from);

  @override
  String get query => '${token.uid} $tableName';
}