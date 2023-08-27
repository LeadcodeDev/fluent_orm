import 'package:fluent_orm/clients/common/clause.dart';

class ReturningClause extends Clause {
  final String value;

  ReturningClause(this.value): super('RETURNING');

  @override
  String get query => '$token $value';
}