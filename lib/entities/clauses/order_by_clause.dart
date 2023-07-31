import 'package:fluent_orm/entities/clause.dart';
import 'package:fluent_orm/entities/clause_token.dart';
import 'package:fluent_orm/entities/order.dart';

class OrderByClause extends Clause {
  final String column;
  final Order order;

  OrderByClause(this.column, this.order): super(ClauseToken.orderBy);

  @override
  String get query => '${token.uid} ${order.value}';
}