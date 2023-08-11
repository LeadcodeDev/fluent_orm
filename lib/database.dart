import 'package:fluent_orm/contracts/query_builder_contract.dart';
import 'package:fluent_orm/entities/model.dart';
import 'package:fluent_orm/entities/model_wrapper.dart';
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

  QueryBuilder<M> forModel<M> () {
    final ModelWrapper model = _manager.resolve<M>();
    final Database<M> database = Database<M>();

    database._builder = QueryBuilder<M>(manager: _manager, model: model);
    database._builder.from(_manager.resolve<M>().tableName);

    return database._builder;
  }

  SelectContract<T> select({ required String table, List<String>? columns = const ['*']}) {
    _builder
      .from(table)
      .select(columns: columns);

    return _builder;
  }

  InsertContract<T> insert({ required String tableName, required Map<String, dynamic> data }) {
    _builder
      ..into(tableName)
      ..insert(data);

    return _builder;
  }

  UpdateContract<T> update({ required String tableName, required Map<String, dynamic> data }) {
    return _builder
      ..update(data)
      ..into(tableName);
  }

  DeleteContract<T> delete({ required String table }) {
    _builder.from(table);
    return _builder;
  }

  Future<bool> exists(String tableName) async {
    final result = await Database.of(_manager)
      .select(table: 'information_schema.tables')
      .where(column: 'table_name', value: tableName)
      .first();

    return result != null;
  }

  QueryBuilder<T> query () => _builder;
}