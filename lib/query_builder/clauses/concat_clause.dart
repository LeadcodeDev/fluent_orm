
import 'package:fluent_orm/query_builder/clause.dart';
import 'package:fluent_orm/query_builder/clause_token.dart';

class ConcatClause extends Clause {
  final List<String> elements;
  final String separator;

  ConcatClause(this.elements, this.separator): super(ClauseToken.concat);

  @override
  String get query {
    final String concat = elements.join(separator);
    return '${token.uid}($concat)';
  }
}