import 'package:fluent_orm/entities/model.dart';
import 'package:fluent_orm/query_builder/declarations/relation.dart';

import 'article.dart';

final class Category extends Model<Category> {
  Category(): super(relations: [Relation<Article>.hasMany()]);

  int get id => properties.get('id');
  String get label => properties.get('label');
  String get description => properties.get('description');
  List<Article> get articles => relations.hasMany<Article>();
}