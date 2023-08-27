import 'package:fluent_orm/clients/common/declarations/relation.dart';
import 'package:fluent_orm/clients/common/model.dart';

import 'article.dart';

final class Category extends Model<Category> {
  Category(): super(relations: [Relation<Article>.hasMany()]);

  String get label => model.property('label');
  String get description => model.property('description');
  List<Article> get articles => model.hasMany<Article>();
}