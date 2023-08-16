import 'package:fluent_orm/query_builder/clauses/delete_clause.dart';
import 'package:fluent_orm/query_builder/clauses/from_clause.dart';
import 'package:fluent_orm/query_builder/clauses/insert_clause.dart';
import 'package:fluent_orm/query_builder/clauses/into_clause.dart';
import 'package:fluent_orm/query_builder/clauses/limit_clause.dart';
import 'package:fluent_orm/query_builder/clauses/offset_clause.dart';
import 'package:fluent_orm/query_builder/clauses/order_by_clause.dart';
import 'package:fluent_orm/query_builder/clauses/returning_clause.dart';
import 'package:fluent_orm/query_builder/clauses/select_clause.dart';
import 'package:fluent_orm/query_builder/clauses/table_clause.dart';
import 'package:fluent_orm/query_builder/clauses/update_clause.dart';
import 'package:fluent_orm/query_builder/clauses/values_clause.dart';
import 'package:fluent_orm/query_builder/clauses/where_clause.dart';

class ClauseStructure {
  SelectClause? select;
  final List<WhereClause> where = [];
  UpdateClause? update;
  LimitClause? limit;
  OffsetClause? offset;
  List<OrderByClause> order = [];
  FromClause? from;
  IntoClause? into;
  TableClause? table;
  InsertClause? insert;
  DeleteClause? delete;
  ValuesClause? values;
  ReturningClause? returning;
}