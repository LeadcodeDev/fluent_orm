import 'package:fluent_orm/clients/postgres_client.dart';
import 'package:fluent_orm/database.dart';
import 'package:fluent_orm/entities/model.dart';
import 'package:fluent_orm/fluent_manager.dart';
import 'package:fluent_orm/mock/model_factory.dart';
import 'package:fluent_orm/query_builder/query_builder.dart';
import 'package:fluent_orm/query_builder/relations/belong_to.dart';
import 'package:fluent_orm/query_builder/relations/has_many.dart';
import 'package:fluent_orm/query_builder/relations/many_to_many.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';
import 'package:faker/faker.dart';

import 'migrations/1691342071_category_schema.dart';
import 'migrations/1691342072_article_schema.dart';
import 'migrations/1691342073_article_tag_schema.dart';
import 'migrations/1691342073_tags_schema.dart';
import 'migrations/1691342075_add_field.dart';
import 'models/article.dart';
import 'models/category.dart';
import 'models/tag.dart';

Future<void> main() async {
  final faker = Faker();
  late final FluentManager manager;

  setUpAll(() async {
    manager =  FluentManager(
      models: [Category.new, Article.new, Tag.new],
      migrations: [
        CategorySchema1691342071.new,
        ArticleSchema1691342072.new,
        TagSchema1691342072.new,
        ArticleTagSchema1691342072.new,
        AddFieldArticle1691342072.new,
      ],
      client: PostgresClient(
        database: 'bot',
        host: 'localhost',
        user: 'postgres',
        password: 'postgres',
        port: 5432
      )
    );

    await expectLater(manager.client.connect(), completes);
  });

  setUp(() async {
    await manager.migrator.fresh();
  });

  test('create Manager with postgres client', () async {
    expect(manager.client, isA<PostgresClient>());
  });

  test('fluent_schema table exists', () async {
    final result = await Database.of(manager)
      .exists('fluent_schemas');

    expect(result, equals(true));
  });

  test('can insert one category without model', () async {
    final result = await Database.of(manager)
      .insert(tableName: 'categories', data:  {
        'label': faker.lorem.word(),
        'description': faker.lorem.sentence(),
      }).save();

    expect(result, isNotNull);
    expect(result, isA<Map>());
  });

  test('can insert one category with model', () async {
    final factory = await ModelFactory.of<Category>(manager).make((faker) => {
      'label': faker.lorem.word(),
      'description': faker.lorem.sentence(),
    });

    expect(factory.model, isNotNull);
    expect(factory.model.label, equals(factory.payload['label']));
    expect(factory.model.description, equals(factory.payload['description']));
  });

  test('get one category without defined model', () async {
    final factory = await ModelFactory.of<Category>(manager).make((faker) => {
      'label': faker.lorem.word(),
      'description': faker.lorem.sentence(),
    });

    final result = await Database.of(manager)
      .select(table: 'categories')
      .where(column: 'id', value: factory.model.id)
      .first();

    expect(result, isNotNull);
    expect(result, isA<Map>());
  });

  test('get one category with defined model', () async {
    final factory = await ModelFactory.of<Category>(manager).make((faker) => {
      'label': faker.lorem.word(),
      'description': faker.lorem.sentence(),
    });

    final result = await Database.of(manager)
      .forModel<Category>()
      .where(column: 'id', value: factory.model.id)
      .first();

    expect(result, isNotNull);
    expect(result, isA<Category>());
    expect(result?.id, isA<int>());
  });

  test('can insert many categories', () async {
    final int count = 5;
    final factories = await ModelFactory.of<Category>(manager).makeMany(count, (faker) => {
      'label': faker.lorem.word(),
      'description': faker.lorem.sentence(),
    });

    expect(factories, isA<List>());
    expect(factories.length, count);
  });

  test('can update one category', () async {
    final factory = await ModelFactory.of<Category>(manager).make((faker) => {
      'label': faker.lorem.word(),
      'description': faker.lorem.sentence(),
    });

    final description = faker.lorem.sentence();
    final category = await factory.model.update({ 'description': description });

    expect(category, isA<Category>());
    expect(category.description, equals(description));
  });

  test('can preload belongTo relation based on model', () async {
    final categoryFactory = await ModelFactory.of<Category>(manager).make((faker) => {
      'label': faker.lorem.word(),
      'description': faker.lorem.sentence(),
    });

    final articleFactory = await ModelFactory.of<Article>(manager).make((faker) => {
      'title': faker.lorem.sentence(),
      'content': faker.lorem.sentence(),
      'category_id': categoryFactory.model.id,
    });

    final result = await Database.of(manager)
      .forModel<Article>()
      .where(column: 'id', value: articleFactory.model.id)
      .preload<Category, BelongTo>()
      .firstOrFail();

    expect(result.category, allOf([isNotNull, isA<Category>()]));
    expect(result.category.label, categoryFactory.model.label);
  });

  test('can preload belongTo relation based on model', () async {
    final int articleCount = 5;
    final categoryFactory = await ModelFactory.of<Category>(manager).make((faker) => {
      'label': faker.lorem.word(),
      'description': faker.lorem.sentence(),
    });

    await ModelFactory.of<Article>(manager).makeMany(articleCount, (faker) => {
      'title': faker.lorem.sentence(),
      'content': faker.lorem.sentence(),
      'category_id': categoryFactory.model.id,
    });

    final result = await Database.of(manager)
      .forModel<Category>()
      .where(column: 'id', value: categoryFactory.model.id)
      .preload<Article, HasMany>()
      .firstOrFail();

    expect(result.articles, allOf([
      isNotNull,
      isA<List<Article>>(),
      hasLength(articleCount)
    ]));
  });

  test('can preload belongTo relation based on model', () async {
    final int tagCount = 5;

    final articleFactory = await ModelFactory.of<Article>(manager).make((faker) => {
      'title': faker.lorem.sentence(),
      'content': faker.lorem.sentence(),
    });

    final tagFactories = await ModelFactory.of<Tag>(manager).makeMany(tagCount, (faker) => {
      'label': faker.lorem.sentence(),
    });

    final Iterable<int> ids = tagFactories.map((e) => e.model.id);
    final query = articleFactory.model
      .related<Tag, ManyToMany>()
      .associate(ids);

    expectLater(query, completes);
  });

  test('can create from related model based on model', () async {
    final factory = await ModelFactory.of<Category>(manager).make((faker) => {
      'label': faker.lorem.word(),
      'description': faker.lorem.sentence(),
    });

    final payload = {
      'title': faker.lorem.sentence(),
      'content': faker.lorem.sentence()
    };

    final article = await factory.model
      .related<Article, HasMany>()
      .create(payload);

    expect(article, allOf([isNotNull, isA<Article>(),
      predicate((Article article) => (article.title == payload['title'])),
      predicate((Article article) => (article.content == payload['content'])),
    ]));
  });

  test('can delete row with defined model', () async {
    final factory = await ModelFactory.of<Category>(manager).make((faker) => {
      'label': faker.lorem.word(),
      'description': faker.lorem.sentence(),
    });

    await expectLater(factory.model.delete(), completes);

    final result = await Database.of(manager)
      .forModel<Category>()
      .where(column: 'id', value: factory.model.id)
      .all();

    expect(result, isA<List>());
    expect(result, hasLength(0));
  });
}