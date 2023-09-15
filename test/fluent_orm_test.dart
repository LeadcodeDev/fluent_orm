import 'package:fluent_orm/clients/common/pagination.dart';
import 'package:fluent_orm/providers/postgres_provider.dart';
import 'package:fluent_orm/clients/common/database.dart';
import 'package:fluent_orm/fluent_manager.dart';
import 'package:fluent_orm/clients/common/declarations/relation.dart';
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
  late final TestFactory factory;

  setUpAll(() async {
    manager =  FluentManager(
      models: [Category.new, Article.new, Tag.new],
      migrations: [
        CategorySchema1691342071.new,
        ArticleSchema1691342072.new,
        TagSchema1691342072.new,
        ArticleTagSchema1691342072.new,
      ],
      provider: PostgresProvider(
        database: 'bot',
        host: 'localhost',
        user: 'postgres',
        password: 'postgres',
        port: 5432
      )
    );

    await expectLater(manager.provider.connect(), completes);
    factory = TestFactory(manager);
  });


  setUp(() async {
    await manager.migrator.fresh();
  });

  test('create Manager with postgres client', () async {
    expect(manager.provider, isA<PostgresProvider>());
  });

  test('fluent_schema table exists', () async {
    final result = await Database.of(manager)
      .exists('fluent_schemas');

    expect(result, equals(true));
  });

  test('can insert one category without model', () async {
    final result = await Database.of(manager).query()
      .table('categories')
      .returning(['*'])
      .insert({
        'label': faker.lorem.word(),
        'description': faker.lorem.sentence(),
      });

    expect(result, isNotNull);
    expect(result, isA<Map>());
  });

  test('can insert one category with model', () async {
    final category = await factory.category.make();

    expect(category.model, isNotNull);
    expect(category.model.label, equals(category.payload['label']));
    expect(category.model.description, equals(category.payload['description']));
  });

  test('get one category without defined model', () async {
    final category = await factory.category.make();

    final result = await Database.of(manager).query()
      .select()
      .from('categories')
      .where(column: 'id', value: category.model.id)
      .first();

    expect(result, isA<Map<String, dynamic>>());
  });

  test('get one category with defined model', () async {
    final category = await factory.category.make();

    final result = await Database.of(manager)
      .model<Category>()
      .find(category.model.id);

    expect(result, isNotNull);
    expect(result, isA<Category>());
    expect(result?.id, isA<int>());
  });

  test('can insert many categories', () async {
    final int count = 5;
    final categories = await factory.category.makeMany(count);

    expect(categories, isA<List>());
    expect(categories, hasLength(count));
  });

  test('can update one category', () async {
    final category = await factory.category.make();

    final description = faker.lorem.sentence();
    final result = await category.model.update({ 'description': description });

    expect(result, isA<Category>());
    expect(result.description, equals(description));
  });

  test('can get all articles', () async {
    final int articleCount = 5;
    await factory.article.makeMany(articleCount);

    final articles = await Database.of(manager)
      .model<Article>()
      .all();

    expect(articles, allOf([
      isNotEmpty,
      isA<List<Article>>(),
      hasLength(articleCount),
    ]));
  });

  test('find with an valid id cannot be nullable', () async {
    final article = await factory.article.make();
    final result = await Database.of(manager)
      .model<Article>()
      .findBy(column: 'id', value: article.model.id);

    expect(result, allOf([
      isNotNull,
      isA<Article>(),
    ]));
  });

  test('find with an invalid id can be nullable', () async {
    await factory.article.make();
    final result = await Database.of(manager)
      .model<Article>()
      .findBy(column: 'id', value: 2);

    expect(result, isNull);
  });

  test('can findBy with an valid column id', () async {
    final article = await factory.article.make();
    final result = await Database.of(manager)
      .model<Article>()
      .find(article.model.id);

    expect(result, allOf([
      isNotNull,
      isA<Article>(),
    ]));
  });

  test('nullable findBy with an invalid column id', () async {
    await factory.article.make();
    final result = await Database.of(manager)
      .model<Article>()
      .find(2);

    expect(result, isNull);
  });

  test('can findOrFail with an valid id', () async {
    final article = await factory.article.make();
    final result = await Database.of(manager)
      .model<Article>()
      .findOrFail(article.model.id);

    expect(result, allOf([
      isNotNull,
      isA<Article>(),
    ]));
  });

  test('cannot findOrFail with an invalid id', () async {
    await factory.article.make();
    final result = Database.of(manager)
      .model<Article>()
      .findOrFail(2);

    await expectLater(result, throwsA(isA<Exception>()));
  });

  test('can findByOrFail with an valid id', () async {
    final article = await factory.article.make();
    final result = await Database.of(manager)
      .model<Article>()
      .findByOrFail(column: 'id', value: article.model.id);

    expect(result, allOf([
      isNotNull,
      isA<Article>(),
    ]));
  });

  test('cannot findByOrFail with an invalid id', () async {
    await factory.article.make();
    final result = Database.of(manager)
      .model<Article>()
      .findByOrFail(column: 'id', value: 2);

    await expectLater(result, throwsA(isA<Exception>()));
  });

  test('can preload belongTo relation based on model', () async {
    final category = await factory.category.make();
    final article = await factory.article.make();

    final result = await Database.of(manager).model<Article>().query()
      .where(column: 'id', value: article.model.id)
      .preload<Category, BelongTo>()
      .first();

    expect(result?.category, allOf([isNotNull, isA<Category>()]));
    expect(result?.category.label, category.model.label);
  });

  test('can preload ManyToMany relation based on model', () async {
    final int articleCount = 5;
    final category = await factory.category.make();

    await factory.article.makeMany(articleCount, mergeWith: { 'category_id': category.model.id });

    final result = await Database.of(manager).model<Category>().query()
      .where(column: 'id', value: category.model.id)
      .preload<Article, HasMany>()
      .first();

    expect(result?.articles, allOf([
      isNotNull,
      isA<List<Article>>(),
      hasLength(articleCount)
    ]));
  });

  test('can preload hasMany relation based on model', () async {
    final int tagCount = 5;
    final article = await factory.article.make();
    final List<int> ids = await factory.tag.makeMany(tagCount)
      .then((tags) => tags.map((tag) => tag.model.id).toList());

    await article.model
      .related<Tag, ManyToMany>()
      .associate(ids);

    final result = await Database.of(manager).model<Article>().query()
      .preload<Tag, ManyToMany>()
      .first();

    expect(result?.tags, allOf([
      isNotNull,
      isA<List<Tag>>(),
      hasLength(tagCount)
    ]));
  });

  test('can associate manyToMany relation based on model', () async {
    final int tagCount = 5;

    final article = await factory.article.make();
    final tags = await factory.tag.makeMany(tagCount);

    final Iterable<int> ids = tags.map((e) => e.model.id);
    final query = article.model
      .related<Tag, ManyToMany>()
      .associate(ids);

    expectLater(query, completes);
  });

  test('can dissociate manyToMany relation based on model', () async {
    final int tagCount = 5;

    final article = await factory.article.make();
    final tags = await factory.tag.makeMany(tagCount);

    final Iterable<int> ids = tags.map((e) => e.model.id);
    await article.model
      .related<Tag, ManyToMany>()
      .associate(ids);

    final dissociate = article.model
      .related<Tag, ManyToMany>()
      .dissociate(ids);

    await expectLater(dissociate, completes);

    final result = await Database.of(manager).model<Article>().query()
      .preload<Tag, ManyToMany>()
      .first();

    expect(result?.tags, allOf([
      isNotNull,
      isA<List<Tag>>(),
      hasLength(0)
    ]));
  });

  test('can create from related model based on model', () async {
    final category = await factory.category.make();

    final payload = {
      'title': faker.lorem.sentence(),
      'content': faker.lorem.sentence()
    };

    final article = await category.model
      .related<Article, HasMany>()
      .create(payload);

    expect(article, allOf([isNotNull, isA<Article>(),
      predicate((Article article) => (article.title == payload['title'])),
      predicate((Article article) => (article.content == payload['content'])),
    ]));
  });

  test('can delete row with defined model', () async {
    final category = await factory.category.make();

    await expectLater(category.model.delete(), completes);

    final result = await Database.of(manager).model<Category>().query()
      .where(column: 'id', value: category.model.id)
      .fetch();

    expect(result, isA<List>());
    expect(result, hasLength(0));
  });

  test('try to paginate 5 results with 2 elements per page', () async {
    final entries = 5;
    final itemsPerPage = 2;

    await factory.article.makeMany(entries);

    final result = await Database.of(manager).model<Article>().query()
      .paginate(page: 1, itemsPerPage: itemsPerPage);

    expect(result, isA<Pagination<Article>>());
    expect(result.data, hasLength(itemsPerPage));
    expect(result.lastPage, (entries / itemsPerPage).ceil());
  });

  test('try to paginate the second page with next() with 2 elements per page', () async {
    final entries = 5;
    final itemsPerPage = 2;

    await factory.article.makeMany(entries);

    final result = await Database.of(manager).model<Article>().query()
      .paginate(page: 1, itemsPerPage: itemsPerPage)
      .then((value) => value.next());

    expect(result, isA<Pagination<Article>>());
    expect(result.data, allOf([isNotEmpty, hasLength(itemsPerPage)]));
    expect(result.lastPage, (entries / itemsPerPage).ceil());
  });

  test('try to paginate the third page with next() with 2 elements per page', () async {
    final entries = 5;
    final itemsPerPage = 2;

    await factory.article.makeMany(entries);

    final result = await Database.of(manager).model<Article>().query()
      .paginate(page: 1, itemsPerPage: itemsPerPage)
      .then((value) => value.next())
      .then((value) => value.next());

    expect(result, isA<Pagination<Article>>());
    expect(result.data, allOf([isNotEmpty, hasLength(1)]));
    expect(result.lastPage, (entries / itemsPerPage).ceil());
  });

  test('try to paginate the third page without calling next() with 2 elements per page', () async {
    final entries = 5;
    final itemsPerPage = 2;

    await factory.article.makeMany(entries);

    final result = await Database.of(manager).model<Article>().query()
      .paginate(page: 3, itemsPerPage: itemsPerPage);

    expect(result, isA<Pagination<Article>>());
    expect(result.data, allOf([isNotEmpty, hasLength(1)]));
    expect(result.lastPage, (entries / itemsPerPage).ceil());
  });

  test('try to paginate empty table', () async {
    final itemsPerPage = 2;

    final result = await Database.of(manager).model<Article>().query()
      .paginate(page: 1, itemsPerPage: itemsPerPage);

    expect(result, isA<Pagination<Article>>());
    expect(result.data, isEmpty);
  });

  test('try to paginate 5 results with 2 elements per page from Model', () async {
    final entries = 5;
    final itemsPerPage = 2;

    await factory.article.makeMany(entries);

    final result = await Database.of(manager)
      .model<Article>()
      .paginate(page: 1, itemsPerPage: itemsPerPage);

    expect(result, isA<Pagination<Article>>());
    expect(result.data, hasLength(itemsPerPage));
    expect(result.lastPage, (entries / itemsPerPage).ceil());
  });

  test('try to paginate the second page with next() with 2 elements per page from Model', () async {
    final entries = 5;
    final itemsPerPage = 2;

    await factory.article.makeMany(entries);

    final result = await Database.of(manager)
        .model<Article>()
        .paginate(page: 1, itemsPerPage: itemsPerPage)
        .then((value) => value.next());

    expect(result, isA<Pagination<Article>>());
    expect(result.data, allOf([isNotEmpty, hasLength(itemsPerPage)]));
    expect(result.lastPage, (entries / itemsPerPage).ceil());
  });

  test('try to paginate the third page with next() with 2 elements per page from Model', () async {
    final entries = 5;
    final itemsPerPage = 2;

    await factory.article.makeMany(entries);

    final result = await Database.of(manager)
        .model<Article>()
        .paginate(page: 1, itemsPerPage: itemsPerPage)
        .then((value) => value.next())
        .then((value) => value.next());

    expect(result, isA<Pagination<Article>>());
    expect(result.data, allOf([isNotEmpty, hasLength(1)]));
    expect(result.lastPage, (entries / itemsPerPage).ceil());
  });

  test('try to paginate the third page without calling next() with 2 elements per page from Model', () async {
    final entries = 5;
    final itemsPerPage = 2;

    await factory.article.makeMany(entries);

    final result = await Database.of(manager)
      .model<Article>()
      .paginate(page: 3, itemsPerPage: itemsPerPage);

    expect(result, isA<Pagination<Article>>());
    expect(result.data, allOf([isNotEmpty, hasLength(1)]));
    expect(result.lastPage, (entries / itemsPerPage).ceil());
  });

  test('try to paginate empty table from Model', () async {
    final itemsPerPage = 2;

    final result = await Database.of(manager)
      .model<Article>()
      .paginate(page: 1, itemsPerPage: itemsPerPage);

    expect(result, isA<Pagination<Article>>());
    expect(result.data, isEmpty);
  });
}