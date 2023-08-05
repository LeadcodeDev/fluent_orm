import 'package:fluent_orm/query_builder/clause.dart';
import 'package:fluent_orm/query_builder/clause_token.dart';

class ValuesClause extends Clause {
  final dynamic values;

  ValuesClause(this.values): super(ClauseToken.value);

  @override
  String get query {
    final values = [];

    if (this.values is List) {
      for (final value in this.values) {
        final concat = value.map((e) => '\'$e\'').join(', ');
        values.add('($concat)');
      }
    } else {
      values.addAll(this.values.map((e) => '\'$e\''));
    }

    final instructions = [token.uid, this.values is List ? values.join(', ') : '(${values.join(', ')})'];

    return instructions.join(' ');
  }
}