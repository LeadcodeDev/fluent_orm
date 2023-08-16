import 'package:fluent_orm/fluent_manager.dart';
import 'package:fluent_orm/mock/model_factory.dart';

import '../models/article.dart';
import '../models/category.dart';
import '../models/tag.dart';

class TestFactory {
  final FluentManager _manager;

  TestFactory(this._manager);

  ModelFactory<Article> get article =>  ModelFactory.of<Article>(_manager).define((faker) => {
    'title': faker.lorem.sentence(),
    'content': faker.lorem.sentence(),
  });

  ModelFactory<Category> get category => ModelFactory.of<Category>(_manager).define((faker) => {
    'label': faker.lorem.word(),
    'description': faker.lorem.sentence(),
  });

  ModelFactory<Tag> get tag => ModelFactory.of<Tag>(_manager).define((faker) => {
    'label': faker.lorem.word(),
  });
}