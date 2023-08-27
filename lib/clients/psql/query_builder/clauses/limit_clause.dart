import 'package:fluent_orm/clients/common/clause.dart';

class LimitClause extends Clause {
  final int value;

  LimitClause(this.value): super('LIMIT');

  @override
  String get query => '$token $value';
}