import 'package:fluent_orm/query_builder/clause.dart';
import 'package:fluent_orm/query_builder/clause_token.dart';

class SelectClause extends Clause {
  final List<String> columns;

  SelectClause({ this.columns = const ['*'] }): super(ClauseToken.select);

  @override
  String get query => '${token.uid} ${columns.join(', ')}';
}