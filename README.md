# Fluent ORM

## Motivation
As a Typescript developer at heart, I've always been accustomed to coming across a multitude of packages in the Node.js ecosystem, each one more incredible than the last, to satisfy my every desire.

![icons technologies](https://skillicons.dev/icons?i=postgres,mysql,dart,flutter)

## No alternative in Dart
When I was learning the [Dart language](https://dart.dev) I was surprised to see, or rather not to have, a wide choice of packages fulfilling the role of an ORM. The only fascinating alternative is Prisma, an adaptation of the world-famous [Prisma ORM](https://www.prisma.io) for the Javascript language.

As a big fan of [Adonis](https://adonisjs.com) as I am, I didn't find the essence of the standards surrounding the database domain, such as migration management, enabling tables to be altered and evolved over time, or the concept of model, the representation of each table within its application.

It was with the aim of solidifying my knowledge in this field while offering a robust and reliable alternative to everyone that I designed **Fluent** : *The model-based ORM for Dart*.

## Our philosophy
With a view to agnostic and cross-platform use, we've decided to free ourselves from the language's reflexion, so that you can still compile your applications to [Javascript](https://dart.dev/web/js-interop), [AOT](https://dart.dev/tools/dart-compile#aot-snapshot), [JIT](https://dart.dev/tools/dart-compile#jit-snapshot) or as [executables](https://dart.dev/tools/dart-compile#exe).

## Example of use
In this example, we're going to create a table called `articles`, which would hypothetically contain a list of subjects with a wide variety of themes.

```dart
// title: Model
import 'package:fluent_orm/fluent_orm.dart';

final class Article extends Model<Article> {
  int get id => model.property('id');
  String get title => model.property('title');
  String get content => model.property('content');
}
```

```dart
// title: Migration
final class Article1691342071 extends Schema {
  final String tableName = 'articles';

  @override
  Future<void> up () async {
    schema.createTable(tableName, (table) {
      table.increments('id');
      table.string('title').notNullable();
      table.text('content');
    });
  }

  @override
  Future<void> down () async {
    schema.dropTable(tableName);
  }
}
```

```dart
// title: QueryBuilder
final articles = await Database.of(manager).model<Article>().query()
  .where(column: 'id', value: 1)
  .fetch();

expect(articles, isA<List<Article>>());
```
