import 'package:fluent_orm/query_builder/clause.dart';
import 'package:fluent_orm/query_builder/clause_token.dart';
import 'package:fluent_orm/query_builder/order.dart';

class OrderByClause extends Clause {
  final String column;
  final Order order;

  OrderByClause(this.column, this.order): super(ClauseToken.orderBy);

  @override
  String get query => '${token.uid} ${order.value}';
}