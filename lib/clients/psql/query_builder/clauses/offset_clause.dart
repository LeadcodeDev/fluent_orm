import 'package:fluent_orm/clients/common/clause.dart';

class OffsetClause extends Clause {
  final int value;

  OffsetClause(this.value): super('OFFSET');

  @override
  String get query => '$token $value';
}