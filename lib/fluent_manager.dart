import 'package:fluent_orm/database.dart';
import 'package:fluent_orm/database/models/fluent_schema.dart';
import 'package:fluent_orm/entities/model.dart';
import 'package:fluent_orm/entities/model_wrapper.dart';
import 'package:fluent_orm/entities/request_manager.dart';
import 'package:fluent_orm/entities/sql_client.dart';
import 'package:fluent_orm/migrator.dart';
import 'package:fluent_orm/query_builder/declarations/declare_property.dart';
import 'package:fluent_orm/query_builder/declarations/declare_relation.dart';
import 'package:fluent_orm/schema_builder/database_schema.dart';
import 'package:fluent_orm/schema_builder/schema.dart';
import 'package:pluralize/pluralize.dart';
import 'package:recase/recase.dart';

class FluentManager {
  final Map<Type, ModelWrapper> models = {};
  final List<Schema> migrations = [];

  late final RequestManager request;
  late final SqlClient client;
  late final Migrator migrator;

  FluentManager({ required this.client, List<Model Function()> models = const [], List<Schema Function()> migrations = const [] }) {
    for (final migration in migrations) {
      _registerMigration(migration);
    }

    _registerModel(FluentSchema.new);
    for (final model in models) {
      _registerModel(model);
    }

    request = RequestManager(this);
    migrator = Migrator(client, this.migrations, () => Database.of(this));
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

  void _registerMigration (Function() constructor) {
    final Schema instance = constructor()
      ..schema = DatabaseSchema(client, Database.of(this));

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
}