import 'package:fluent_orm/clients/postgres_client.dart';
import 'package:fluent_orm/database.dart';
import 'package:fluent_orm/fluent_manager.dart';
import 'package:fluent_orm/mock/model_factory.dart';
import 'package:fluent_orm/query_builder/relations/belong_to.dart';
import 'package:fluent_orm/query_builder/relations/has_many.dart';
import 'package:fluent_orm/query_builder/relations/many_to_many.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';
import 'package:faker/faker.dart';

import 'factories/test_factory.dart';
import 'migrations/1691342071_category_schema.dart';
import 'migrations/1691342072_article_schema.dart';
import 'migrations/1691342073_article_tag_schema.dart';
import 'migrations/1691342073_tags_schema.dart';
import 'models/article.dart';
import 'models/category.dart';
import 'models/tag.dart';

Future<void> main() async {
  final faker = Faker();
  late final FluentManager manager;
  late final TestFactory factory;;

  setUpAll(() async {
    manager =  FluentManager(
      models: [Category.new, Article.new, Tag.new],
      migrations: [
        CategorySchema1691342071.new,
        ArticleSchema1691342072.new,
        TagSchema1691342072.new,
        ArticleTagSchema1691342072.new,
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
    factory = TestFactory(manager);
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

  test('test', () async {
    final article = await Database.of(manager).model<()
  });

  // test('can insert one category without model', () async {
  //   final result = await Database.of(manager)
  //     .insert(tableName: 'categories', data:  {
  //       'label': faker.lorem.word(),
  //       'description': faker.lorem.sentence(),
  //     }).save();
  //
  //   expect(result, isNotNull);
  //   expect(result, isA<Map>());
  // });
  //
  // test('can insert one category with model', () async {
  //   final category = await factory.category.make();
  //
  //   expect(category.model, isNotNull);
  //   expect(category.model.label, equals(category.payload['label']));
  //   expect(category.model.description, equals(category.payload['description']));
  // });
  //
  // test('get one category without defined model', () async {
  //   final category = await factory.category.make();
  //
  //   final result = await Database.of(manager)
  //     .select(table: 'categories')
  //     .where(column: 'id', value: category.model.id)
  //     .first();
  //
  //   await Database.of(manager).update({})
  //     .table('categories')
  //     .where(column: 'id', value: category.model.id)
  //     .put();
  //
  //   expect(result, isNotNull);
  //   expect(result, isA<Map>());
  // });
  //
  // test('get one category with defined model', () async {
  //   final category = await factory.category.make();
  //
  //   final result = await Database.of(manager)
  //     .forModel<Category>()
  //     .where(column: 'id', value: category.model.id)
  //     .first();
  //
  //   expect(result, isNotNull);
  //   expect(result, isA<Category>());
  //   expect(result?.id, isA<int>());
  // });
  //
  // test('can insert many categories', () async {
  //   final int count = 5;
  //   final categories = await factory.category.makeMany(count);
  //
  //   expect(categories, isA<List>());
  //   expect(categories, hasLength(count));
  // });
  //
  // test('can update one category', () async {
  //   final category = await factory.category.make();
  //
  //   final description = faker.lorem.sentence();
  //   final result = await category.model.update({ 'description': description });
  //
  //   expect(result, isA<Category>());
  //   expect(result.description, equals(description));
  // });
  //
  // test('can preload belongTo relation based on model', () async {
  //   final category = await factory.category.make();
  //   final article = await factory.article.make();
  //
  //   final result = await Database.of(manager)
  //     .forModel<Article>()
  //     .where(column: 'id', value: article.model.id)
  //     .preload<Category, BelongTo>()
  //     .firstOrFail();
  //
  //   expect(result.category, allOf([isNotNull, isA<Category>()]));
  //   expect(result.category.label, category.model.label);
  // });
  //
  // test('can preload hasMany relation based on model', () async {
  //   final int articleCount = 5;
  //   final category = await factory.category.make();
  //
  //   await factory.article.makeMany(articleCount, mergeWith: { 'category_id': category.model.id });
  //
  //   final result = await Database.of(manager)
  //     .forModel<Category>()
  //     .where(column: 'id', value: category.model.id)
  //     .preload<Article, HasMany>()
  //     .firstOrFail();
  //
  //   expect(result.articles, allOf([
  //     isNotNull,
  //     isA<List<Article>>(),
  //     hasLength(articleCount)
  //   ]));
  // });
  //
  // test('can associate manyToMany relation based on model', () async {
  //   final int tagCount = 5;
  //
  //   final article = await factory.article.make();
  //   final tags = await factory.tag.makeMany(tagCount);
  //
  //   final Iterable<int> ids = tags.map((e) => e.model.id);
  //   final query = article.model
  //     .related<Tag, ManyToMany>()
  //     .associate(ids);
  //
  //   expectLater(query, completes);
  // });
  //
  // test('can create from related model based on model', () async {
  //   final category = await factory.category.make();
  //
  //   final payload = {
  //     'title': faker.lorem.sentence(),
  //     'content': faker.lorem.sentence()
  //   };
  //
  //   final article = await category.model
  //     .related<Article, HasMany>()
  //     .create(payload);
  //
  //   expect(article, allOf([isNotNull, isA<Article>(),
  //     predicate((Article article) => (article.title == payload['title'])),
  //     predicate((Article article) => (article.content == payload['content'])),
  //   ]));
  // });
  //
  // test('can delete row with defined model', () async {
  //   final category = await factory.category.make();
  //
  //   await expectLater(category.model.delete(), completes);
  //
  //   final result = await Database.of(manager)
  //     .forModel<Category>()
  //     .where(column: 'id', value: category.model.id)
  //     .all();
  //
  //   expect(result, isA<List>());
  //   expect(result, hasLength(0));
  // });
}