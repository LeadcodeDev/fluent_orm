import 'package:fluent_orm/entities/clauses/delete_clause.dart';
import 'package:fluent_orm/entities/clauses/from_clause.dart';
import 'package:fluent_orm/entities/clauses/insert_clause.dart';
import 'package:fluent_orm/entities/clauses/limit_clause.dart';
import 'package:fluent_orm/entities/clauses/offset_clause.dart';
import 'package:fluent_orm/entities/clauses/returning_clause.dart';
import 'package:fluent_orm/entities/clauses/select_clause.dart';
import 'package:fluent_orm/entities/clauses/update_clause.dart';
import 'package:fluent_orm/entities/clauses/values_clause.dart';
import 'package:fluent_orm/entities/clauses/where_clause.dart';
import 'package:fluent_orm/entities/order.dart';

class ClauseStructure {
  final List<SelectClause> select = [];
  final List<WhereClause> where = [];
  UpdateClause? update;
  LimitClause? limit;
  OffsetClause? offset;
  List<Order> order = [];
  FromClause? from;
  InsertClause? insert;
  DeleteClause? delete;
  ValuesClause? values;
  ReturningClause? returning;
}