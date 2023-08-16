import 'package:fluent_orm/database.dart';
import 'package:fluent_orm/entities/model_wrapper.dart';
import 'package:fluent_orm/fluent_manager.dart';
import 'package:fluent_orm/query_builder/query_builder.dart';

abstract interface class ModelQueryBuilderContract {
  Future<void> create (Map<String, dynamic> payload);
}

class ModelQueryBuilder<T> extends QueryBuilder<T> implements ModelQueryBuilderContract {
  final FluentManager _manager;
  final ModelWrapper _model;

  ModelQueryBuilder(this._manager, this._model): super(manager: _manager, model: _model);

  @override
  Future<void> create (Map<String, dynamic> payload) async {
    return into(_model.tableName)
      .insert(payload);
  }
}