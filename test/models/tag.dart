import 'package:fluent_orm/entities/model.dart';

final class Tag extends Model<Tag> {
  Tag(): super(
    properties: ['id', 'label'],
  );

  int get id => properties.get('id');
  String get label => properties.get('label');
}