import 'package:fluent_orm/clients/common/database.dart';
import 'package:fluent_orm/clients/common/database/migrations/fluent_schema_migration.dart';
import 'package:fluent_orm/clients/common/database/models/fluent_schema.dart';
import 'package:fluent_orm/clients/common/schema.dart';
import 'package:fluent_orm/clients/common/abstract_provider.dart';
import 'package:recase/recase.dart';

class Migrator {
  final AbstractProvider _provider;
  final List<Schema> _migrations;
  final Database Function() _database;

  Migrator(this._provider, this._migrations, this._database);

  Future<void> createSchemaTable () async {
    final FluentSchemaMigration fluentSchema = FluentSchemaMigration()
      ..schema = _provider.makeSchema(_database());

    await fluentSchema.up();
  }

  Future<List> _getMigratedSchema ({ int? batch }) async {
    final builder = _database().query();
    if (batch != null) {
      builder.where(column: 'batch', value: batch);
    }

    return builder.fetch();
  }

  Future<int> _getLastBatch () async {
    final batch = await _provider.execute('SELECT MAX(batch) FROM fluent_schemas')
      .then((value) => value.first.firstOrNull);

    return batch ?? 0;
  }

  Future<void> run () async {
    if (!await _database().exists('fluent_schemas')) {
      await createSchemaTable();
    }

    final lastBatch = await _getLastBatch();

    final alreadyMigratedNames = await _getMigratedSchema()
      .then((migrations) => migrations.map((e) => e.name)
      .toList());

    final notMigrated = _migrations.where((migration) {
      final String migrationName = migration.runtimeType.toString().snakeCase;
      return !alreadyMigratedNames.contains(migrationName);
    });

    for (final migration in notMigrated) {
      await migration.up();

      await _database().model<FluentSchema>().create({
        'name': migration.runtimeType.toString().snakeCase,
        'batch': lastBatch + 1,
        'migration_time': DateTime.now().toIso8601String()
      });
    }
  }

  Future<void> rollback () async {
    if (!await _database().exists('fluent_schemas')) {
      await createSchemaTable();
    }

    final lastBatch = await _getLastBatch();
    final alreadyMigratedNames = await _getMigratedSchema(batch: lastBatch)
      .then((migrations) => migrations.map((e) => e.name)
      .toList());

    final migrations = _migrations.reversed.where((migration) {
      final String migrationName = migration.runtimeType.toString().snakeCase;
      return alreadyMigratedNames.contains(migrationName);
    });

    for (final migration in migrations) {
      await migration.down();
    }
  }

  Future<void> fresh () async {
    final tables = await _database().query()
      .select()
      .from('pg_tables')
      .where(column: 'schemaname', value: 'public')
      .fetch();

    if (tables.isNotEmpty) {
      final tableNames = tables.map((row) => row['tablename']).toList();

      await _provider.execute('DROP TABLE IF EXISTS ${tableNames.join(', ')} CASCADE;');
    }

    await run();
  }
}