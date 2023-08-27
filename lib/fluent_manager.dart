import 'package:fluent_orm/clients/common/abstract_provider.dart';
import 'package:fluent_orm/clients/common/database.dart';
import 'package:fluent_orm/clients/common/database/models/fluent_schema.dart';
import 'package:fluent_orm/clients/common/migrator.dart';
import 'package:fluent_orm/clients/common/model.dart';
import 'package:fluent_orm/clients/common/model_wrapper.dart';
import 'package:fluent_orm/clients/psql/query_builder/psql_request_manager.dart';
import 'package:fluent_orm/clients/common/schema.dart';
import 'package:pluralize/pluralize.dart';
import 'package:recase/recase.dart';

class FluentManager {
  final Map<Type, ModelWrapper> models = {};
  final List<Schema> migrations = [];

  late final RequestManager request;
  late final AbstractProvider provider;
  late final Migrator migrator;

  FluentManager({ required this.provider, List<Model Function()> models = const [], List<Schema Function()> migrations = const [] }) {
    for (final migration in migrations) {
      _registerMigration(migration);
    }

    _registerModel(FluentSchema.new);
    for (final model in models) {
      _registerModel(model);
    }

    request = RequestManager(this);
    migrator = Migrator(provider, this.migrations, () => Database.of(this));
  }

  void _registerModel (Function() constructor) {
    final Model instance = constructor();
    final String modelName = instance.runtimeType.toString().snakeCase;

    if (!models.containsKey(instance.runtimeType)) {
      final internalModel = instance.model as InternalModel;
      final relations = internalModel.relations.relations
          .map((e) => e..manager = this)
          .toList();

      final modelWrapper = ModelWrapper(
        instance.runtimeType,
        instance.primaryKey,
        Pluralize().plural(modelName),
        modelName,
        constructor,
        relations,
        internalModel.hooks
      );

      models.putIfAbsent(instance.runtimeType, () => modelWrapper);
    }
  }

  void _registerMigration (Function() constructor) {
    final Schema instance = constructor()
      ..schema = provider.makeSchema(Database.of(this));

    migrations.add(instance);
  }

  ModelWrapper resolve<T> () {
    final ModelWrapper? model = resolveOrNull<T>();

    return switch (model) {
      ModelWrapper() => model,
      _ => throw Exception('Model not found'),
    };
  }

  ModelWrapper? resolveOrNull<T>() => models[T];

  ModelWrapper resolveFromType (Type type) {
    final ModelWrapper? model = models[type];
    return switch (model) {
      ModelWrapper() => model,
      _ => throw Exception('Model not found'),
    };
  }
}