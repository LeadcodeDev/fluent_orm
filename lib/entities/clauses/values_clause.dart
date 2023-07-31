import 'package:fluent_orm/entities/clause.dart';
import 'package:fluent_orm/entities/clause_token.dart';

class ValuesClause extends Clause {
  final List values;
  final bool multiple;

  ValuesClause(this.values, { this.multiple = false }): super(ClauseToken.value);

  @override
  String get query {
    final values = [];

    if (multiple) {
      for (final value in this.values) {
        final concat = value.map((e) => '\'$e\'').join(', ');
        values.add('($concat)');
      }
    } else {
      values.addAll(this.values.map((e) => '\'$e\''));
    }

    final instructions = [token.uid, multiple ? values.join(', ') : '(${values.join(', ')})'];

    return instructions.join(' ');
  }
}