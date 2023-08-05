import 'package:fluent_orm/entities/model.dart';
import 'package:fluent_orm/entities/model_wrapper.dart';
import 'package:fluent_orm/entities/request_manager.dart';
import 'package:fluent_orm/entities/sql_client.dart';
import 'package:fluent_orm/query_builder/declarations/declare_property.dart';
import 'package:fluent_orm/query_builder/declarations/declare_relation.dart';

import 'package:pluralize/pluralize.dart';
import 'package:recase/recase.dart';

class FluentManager {
  final Map<Type, ModelWrapper> models = {};
  late final RequestManager request;
  late final SqlClient client;

  FluentManager({ required this.client, List<Function()> models = const [] }) {
    request = RequestManager(this);
    for (final model in models) {
      _registerModel(model);
    }
  }

  void _registerModel (Function() constructor) {
    final Model instance = constructor();
    final String modelName = instance.runtimeType.toString().snakeCase;

    if (!models.containsKey(instance.runtimeType)) {
      models.putIfAbsent(instance.runtimeType, () => ModelWrapper(
        instance.runtimeType,
        Pluralize().plural(modelName),
        modelName,
        constructor,
        (instance.properties as DeclareProperty).properties,
        (instance.relations as DeclareRelation).relations
      ));
    }
  }

  ModelWrapper resolve<T> () {
    final ModelWrapper? model = models[T];

    return switch (model) {
      ModelWrapper() => model,
      _ => throw Exception('Model not found'),
    };
  }
}