import 'package:fluent_orm/entities/model.dart';

final class Category extends Model<Category> {
  Category(): super(
    properties: ['id', 'label']
  );

  String get label => properties.get('label');
}