import 'package:fluent_orm/clients/common/abstract_database_schema.dart';
import 'package:fluent_orm/fluent_manager.dart';

abstract class Schema {
  late final FluentManager manager;
  late final AbstractDatabaseSchema schema;

  Future<void> up();
  Future<void> down();
}