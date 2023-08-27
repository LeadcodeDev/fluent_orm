import 'package:fluent_orm/clients/common/model.dart';

final class Tag extends Model<Tag> {
  String get label => model.property('label');
}