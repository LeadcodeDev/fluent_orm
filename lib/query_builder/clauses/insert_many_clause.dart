import 'package:fluent_orm/query_builder/clauses/insert_clause.dart';

class InsertManyClause extends InsertClause {
  InsertManyClause(super.tableName, super.payload);

  @override
  String get query {
    final columns = payload.first.keys.join(', ');
    final values = payload
      .map((element) => element.values.map((value) => '\'$value\''))
      .map((element) => '(${element.join(', ')})');

    final instructions = [token.uid, tableName, '($columns)', 'VALUES', values.join(', ')];
    return instructions.join(' ');
  }
}