import 'package:fluent_orm/clients/common/abstract_model_query_builder.dart';
import 'package:fluent_orm/fluent_manager.dart';
import 'package:fluent_orm/clients/common/abstract_query_builder.dart';
import 'package:fluent_orm/clients/common/abstract_standalone_query_builder.dart';
import 'package:fluent_orm/clients/common/model_wrapper.dart';

class Database<T> {
  late final FluentManager _manager;
  late final AbstractQueryBuilder _builder;

  static Database of(FluentManager manager) {
    final Database database = Database();
    database._manager = manager;
    database._builder = manager.provider.makeQueryBuilder(manager);

    return database;
  }

  AbstractModelQueryBuilder<M> model<M> () {
    final ModelWrapper model = _manager.resolve<M>();
    final Database<M> database = Database<M>()
      .._builder = _manager.provider.makeModelQueryBuilder<M>(_manager, model)
      .._manager = _manager;

    return database._builder as AbstractModelQueryBuilder<M>;
  }

  Future<bool> exists(String tableName) async {
    final result = await Database.of(_manager).query()
      .select()
      .from('information_schema.tables')
      .where(column: 'table_name', value: tableName)
      .limit(1)
      .fetch();

    return result.firstOrNull != null;
  }

  AbstractStandaloneQueryBuilder<T> query () => _builder as AbstractStandaloneQueryBuilder<T>;
}