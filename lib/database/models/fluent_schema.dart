import 'package:fluent_orm/entities/model.dart';

class FluentSchema extends Model {
  int get id => properties.get('id');
  String get name => properties.get('name');
  int get batch => properties.get('batch');
  String get migrationTime => properties.get('migration_time');
}