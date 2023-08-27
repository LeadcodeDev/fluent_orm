import 'package:fluent_orm/clients/common/clause.dart';

class UpdateClause extends Clause {
  UpdateClause(): super('UPDATE');

  @override
  String get query => token;
}