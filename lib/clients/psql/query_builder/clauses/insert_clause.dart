import 'package:fluent_orm/clients/common/clause.dart';

class InsertClause extends Clause {
  InsertClause(): super('INSERT');

  @override
  String get query => token;
}