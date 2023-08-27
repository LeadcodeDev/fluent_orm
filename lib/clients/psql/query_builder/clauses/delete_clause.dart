import 'package:fluent_orm/clients/common/clause.dart';

class DeleteClause extends Clause {
  DeleteClause(): super('DELETE');

  @override
  String get query => token;
}