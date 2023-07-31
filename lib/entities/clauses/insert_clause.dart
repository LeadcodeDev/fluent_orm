import 'package:fluent_orm/entities/clause.dart';
import 'package:fluent_orm/entities/clause_token.dart';

class InsertClause extends Clause {
  final String tableName;
  final List<String> columns;

  InsertClause(this.tableName, this.columns): super(ClauseToken.insert);

  @override
  String get query {
    final instructions = [token.uid, tableName, '(${columns.join(', ')})'];
    return instructions.join(' ');
  }
}