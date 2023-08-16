import 'package:fluent_orm/query_builder/clause.dart';
import 'package:fluent_orm/query_builder/clause_token.dart';
import 'package:fluent_orm/query_builder/clauses/values_clause.dart';

class InsertClause extends Clause {
  final String tableName;
  dynamic payload;

  InsertClause(this.tableName, this.payload): super(ClauseToken.insert);

  @override
  String get query {
    final columns = payload.keys.join(', ');
    final values = ValuesClause(payload.values);

    final instructions = [token.uid, tableName, '($columns)', values.query];
    return instructions.join(' ');
  }
}