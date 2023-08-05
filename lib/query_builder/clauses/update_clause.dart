import 'package:fluent_orm/query_builder/clause.dart';
import 'package:fluent_orm/query_builder/clause_token.dart';

class UpdateClause extends Clause {
  final String tableName;
  final Map<String, dynamic> payload;

  UpdateClause(this.tableName, this.payload): super(ClauseToken.update);

  @override
  String get query {
    final e = payload.entries.fold([], (acc, element) => [...acc, '${element.key} = \'${element.value}\'']);
    final instructions = [token.uid, tableName, 'SET', e.join(', ')];

    return instructions.join(' ');
  }
}