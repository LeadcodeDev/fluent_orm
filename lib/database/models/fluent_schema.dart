import 'package:fluent_orm/clients/common/model.dart';

class FluentSchema extends Model {
  String get name => model.property('name');
  int get batch => model.property('batch');
  String get migrationTime => model.property('migration_time');
}