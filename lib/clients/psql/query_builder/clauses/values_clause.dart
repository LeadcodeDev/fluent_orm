import 'package:fluent_orm/clients/common/clause.dart';

class ValuesClause extends Clause {
  final dynamic values;

  ValuesClause(this.values): super('VALUES');

  @override
  String get query {
    final values = [];
    final columns = [];

    if (this.values is List) {
      for (final Map<String, dynamic> value in this.values) {
        final concat = value.values.map((e) => '\'$e\'').join(', ');
        values.add('($concat)');

        for (final key in value.keys) {
          if (!columns.contains(key)) {
            columns.add(key);
          }
        }
      }
    }

    if (this.values is Map) {
      columns.addAll((this.values as Map).keys);
      values.addAll((this.values as Map).values.map((e) => '\'$e\''));
    }

    final instructions = ['(${columns.join(', ')})', token, this.values is List ? values.join(', ') : '(${values.join(', ')})'];

    return instructions.join(' ');
  }
}