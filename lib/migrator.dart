import 'package:fluent_orm/database.dart';
import 'package:fluent_orm/database/migrations/fluent_schema_migration.dart';
import 'package:fluent_orm/database/models/fluent_schema.dart';
import 'package:fluent_orm/entities/sql_client.dart';
import 'package:fluent_orm/schema_builder/database_schema.dart';
import 'package:fluent_orm/schema_builder/schema.dart';
import 'package:recase/recase.dart';

class Migrator {
  final SqlClient _client;
  final List<Schema> _migrations;
  final Database Function() _database;

  Migrator(this._client, this._migrations, this._database);

  Future<void> createSchemaTable () async {
    final FluentSchemaMigration fluentSchema = FluentSchemaMigration()
      ..schema = DatabaseSchema(_client, _database());

    await fluentSchema.up();
  }

  Future<List<FluentSchema>> _getMigratedSchema ({ int? batch }) async {
    final builder = _database().forModel<FluentSchema>().select();
    if (batch != null) {
      builder.where(column: 'batch', value: batch);
    }

    return builder.all();
  }

  Future<int> _getLastBatch () async {
    final batch = await _client.execute('SELECT MAX(batch) FROM fluent_schemas')
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

      await _database().forModel<FluentSchema>().insert({
        'name': migration.runtimeType.toString().snakeCase,
        'batch': lastBatch + 1,
        'migration_time': DateTime.now().toIso8601String()
      })
      .save();
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

      await _database().forModel<FluentSchema>()
        .where(column: 'name', value: migration.runtimeType.toString().snakeCase)
        .del();
    }
  }

  Future<void> fresh () async {
    final tables = await _database()
      .select(table: 'pg_tables')
      .where(column: 'schemaname', value: 'public')
      .all();

    if (tables.isNotEmpty) {
      final tableNames = tables.map((row) => row['tablename']).toList();

      await _client.execute('DROP TABLE IF EXISTS ${tableNames.join(', ')} CASCADE;');
    }

    await run();
  }
}