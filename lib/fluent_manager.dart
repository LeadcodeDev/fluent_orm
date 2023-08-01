import 'package:fluent_orm/entities/model.dart';
import 'package:fluent_orm/entities/model_wrapper.dart';
import 'package:recase/recase.dart';

class FluentManager {
  final Map<Type, ModelWrapper> models = {};
  final _connexion;

  FluentManager(this._connexion, List<Function()> models) {
    for (final model in models) {}
  }

  void _rgisterModel (Function() constructor) {
    final Model instance = constructor();
    final String modelName = instance.runtimeType.toString().snakeCase;

    if (!models.containsKey(instance.runtimeType)) {
      models.putIfAbsent(instance.runtimeType, () => ModelWrapper(
        instance.runtimeType,
        modelName,
        modelName,
        constructor,
        []
        // (instance.properties as DeclareProperty).properties,
        // (instance.relations as DeclareRelation).relations
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