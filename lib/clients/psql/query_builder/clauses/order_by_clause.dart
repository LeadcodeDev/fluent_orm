import 'package:fluent_orm/clients/common/clause.dart';
import 'package:fluent_orm/clients/common/order.dart';

class OrderByClause extends Clause {
  final String column;
  final Order order;

  OrderByClause(this.column, this.order): super('ORDER BY');

  @override
  String get query => '$token ${order.value}';
}