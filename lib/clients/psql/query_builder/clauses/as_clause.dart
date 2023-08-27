import 'package:fluent_orm/clients/common/clause.dart';

class AsClause extends Clause {
  final String value;

  AsClause(this.value): super('AS');

  @override
  String get query => '$token $value';
}