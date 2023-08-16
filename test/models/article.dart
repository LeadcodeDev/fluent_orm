import 'package:fluent_orm/entities/model.dart';
import 'package:fluent_orm/hook_model.dart';
import 'package:fluent_orm/query_builder/declarations/relation.dart';

import 'category.dart';

final class Article extends Model<Article> {
  Article(): super(
    relations: [Relation<Category>.belongTo()],
    // hooks: HookModel(
    //   beforeCreate: beforeCreate
    // )
  );

  static void beforeCreate (article) {
    article.title = 'Before Create';
    article.content = 'Before Create Content';
  }

  int get id => properties.get('id');
  String get title => properties.get('title');
  String get content => properties.get('content');
  Category get category => relations.belongTo<Category>();
}