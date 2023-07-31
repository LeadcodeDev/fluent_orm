import 'package:fluent_orm/entities/clause.dart';
import 'package:fluent_orm/entities/clause_token.dart';

class SelectClause extends Clause {
  final List<String> columns;

  SelectClause({ this.columns = const ['*'] }): super(ClauseToken.select);

  @override
  String get query => '${token.uid} ${columns.join(', ')}';
}