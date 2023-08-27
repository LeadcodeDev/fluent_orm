import 'package:fluent_orm/database/model.dart';

import 'category.dart';
import 'tag.dart';

final class Article extends Model<Article> {
  Article(): super(
    relations: [
      Relation<Category>.belongTo(),
      Relation<Tag>.manyToMany()
    ],
    hooks: HookModel(
      beforeCreate: [beforeCreate]
    )
  );

  static Future<void> beforeCreate (article) async {
    article.title = 'Before Create';
    article.content = 'Before Create Content';
  }

  String get title => model.property('title');
  String get content => model.property('content');

  Category get category => model.belongTo<Category>();
  List<Tag> get tags => model.manyToMany<Tag>();
}