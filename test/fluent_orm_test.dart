import 'package:fluent_orm/clients/postgres_client.dart';
import 'package:fluent_orm/database.dart';
import 'package:fluent_orm/fluent_manager.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'models/category.dart';

Future<void> main() async {
  final manager = FluentManager(
    models: [Category.new],
    client: PostgresClient(
      database: 'bot',
      host: 'localhost',
      user: 'postgres',
      password: 'postgres',
      port: 5432
    )
  );

  await manager.client.connect();

  test('create postgres client', () {
    expect(manager.client, isA<PostgresClient>());
  });

  test('get values without defined model', () async {
    final result = await Database.of(manager)
      .select(table: 'categories')
      .where(column: 'id', value: 1)
      .get();

    expect(result, isA<List<Map>>());
  });

  test('get values of defined model', () async {
    final result = await Database.of(manager)
      .forModel<Category>()
      .select(columns: ['id', 'label'])
      .where(column: 'id', value: 1)
      .get();

    expect(result, isA<List<Category>>());
  });

  test('get one value without defined model', () async {
    final result = await Database.of(manager)
      .select(table: 'categories')
      .where(column: 'id', value: 1)
      .first();

    expect(result, isNotNull);
    expect(result, isA<Map>());
  });

  test('get one value without defined model', () async {
    final result = await Database.of(manager)
      .forModel<Category>()
      .select()
      .where(column: 'id', value: 1)
      .first();

    expect(result, isNotNull);
    expect(result, isA<Category>());
  });
}
