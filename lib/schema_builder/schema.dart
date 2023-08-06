import 'package:fluent_orm/fluent_manager.dart';
import 'package:fluent_orm/schema_builder/database_schema.dart';

abstract class Schema {
  late final FluentManager manager;
  late final DatabaseSchema schema;
}