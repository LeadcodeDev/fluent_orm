import 'package:fluent_orm/contracts/query_builder_contract.dart';
import 'package:fluent_orm/entities/model.dart';
import 'package:fluent_orm/fluent_manager.dart';
import 'package:fluent_orm/query_builder/query_builder.dart';

class Database<T> {
  late final FluentManager _manager;
  late final QueryBuilder<T> _builder;

  static Database of(FluentManager manager) {
    final Database database = Database();
    database._manager = manager;
    database._builder = QueryBuilder(manager: manager);

    return database;
  }

  QueryBuilder<M> forModel<M extends Model> () {
    final Database<M> database = Database<M>();
    database._builder = QueryBuilder<M>(manager: _manager);
    database._builder.from(_manager.resolve<M>().tableName);

    return database._builder;
  }

  SelectContract<T> select({ required String table, List<String>? columns = const ['*']}) {
    _builder
      .from(table)
      .select(columns: columns);

    return _builder;
  }

  InsertContract<T> insert({ required String table, required Map<String, dynamic> data }) {
    _builder.insert(table, data);
    return _builder;
  }

  UpdateContract<T> update({ required String table, required Map<String, dynamic> data }) {
    _builder.update(table, data);
    return _builder;
  }

  DeleteContract<T> delete({ required String table }) {
    _builder.from(table);
    return _builder;
  }
}