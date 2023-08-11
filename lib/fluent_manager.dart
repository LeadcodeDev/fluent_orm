import 'package:fluent_orm/database.dart';
import 'package:fluent_orm/database/migrations/fluent_schema_migration.dart';
import 'package:fluent_orm/database/models/fluent_schema.dart';
import 'package:fluent_orm/entities/model.dart';
import 'package:fluent_orm/entities/model_wrapper.dart';
import 'package:fluent_orm/entities/request_manager.dart';
import 'package:fluent_orm/entities/sql_client.dart';
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

  FluentManager({  required this.client, List<Model Function()> models = const [], List<Schema Function()> migrations = const [] }) {
    request = RequestManager(this);

    for (final migration in migrations) {
      _registerMigration(migration);
    }

    _registerModel(FluentSchema.new);
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

  void _registerMigration (Function() constructor) {
    final Schema instance = constructor()
      ..schema = DatabaseSchema(this)
      ..manager = this;

    migrations.add(instance);
  }

  Future<void> createSchemaTable () async {
    final FluentSchemaMigration fluentSchema = FluentSchemaMigration()
      ..schema = DatabaseSchema(this)
      ..manager = this;

    await fluentSchema.up();
  }

  Future<List<FluentSchema>> getMigratedSchema ({ int? batch }) async {
    final builder = Database.of(this).forModel<FluentSchema>().select();
    if (batch != null) {
      builder.where(column: 'batch', value: batch);
    }

    return builder.get();
  }

  Future<int> getLastBatch () async {
    final batch = await client.execute('SELECT MAX(batch) FROM fluent_schemas')
      .then((value) => value.first.firstOrNull);

    return batch ?? 0;
  }

  Future<void> runMigration () async {
    if (!await Database.of(this).exists('fluent_schemas')) {
      await createSchemaTable();
    }

    final lastBatch = await getLastBatch();

    final alreadyMigratedNames = await getMigratedSchema()
      .then((migrations) => migrations.map((e) => e.name)
      .toList());

    final notMigrated = migrations.where((migration) {
      final String migrationName = migration.runtimeType.toString().snakeCase;
      return !alreadyMigratedNames.contains(migrationName);
    });

    for (final migration in notMigrated) {
      await migration.up();

      await Database.of(this)
        .forModel<FluentSchema>()
        .insert({
          'name': migration.runtimeType.toString().snakeCase,
          'batch': lastBatch + 1,
          'migration_time': DateTime.now().toIso8601String()
        })
        .save();
    }
  }

  Future<void> rollbackMigration () async {
    if (!await Database.of(this).exists('fluent_schemas')) {
      await createSchemaTable();
    }

    final lastBatch = await getLastBatch();
    final alreadyMigratedNames = await getMigratedSchema(batch: lastBatch)
      .then((migrations) => migrations.map((e) => e.name)
      .toList());

    final migrations = this.migrations.reversed.where((migration) {
      final String migrationName = migration.runtimeType.toString().snakeCase;
      return alreadyMigratedNames.contains(migrationName);
    });

    for (final migration in migrations) {
      await migration.down();
      await Database.of(this)
        .forModel<FluentSchema>()
        .where(column: 'name', value: migration.runtimeType.toString().snakeCase)
        .del();
    }
  }

  Future<void> freshMigration () async {
    final tables = await Database.of(this)
      .select(table: 'pg_tables')
      .where(column: 'schemaname', value: 'public')
      .get();

    if (tables.isNotEmpty) {
      final tableNames = tables.map((row) => row['tablename']).toList();

      await client.execute('DROP TABLE IF EXISTS ${tableNames.join(', ')} CASCADE;');
    }

    await runMigration();
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