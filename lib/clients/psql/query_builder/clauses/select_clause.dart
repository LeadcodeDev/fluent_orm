import 'package:fluent_orm/clients/common/clause.dart';

class SelectClause extends Clause {
  final List<String> columns;

  SelectClause(this.columns): super('SELECT');

  @override
  String get query => '$token ${columns.join(', ')}';
}