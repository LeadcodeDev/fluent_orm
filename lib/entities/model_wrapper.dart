import 'package:fluent_orm/entities/model_builder.dart';
import 'package:fluent_orm/hook_model.dart';
import 'package:fluent_orm/query_builder/declarations/relation.dart';

class ModelWrapper {
  final Type type;
  final String modelName;
  final String tableName;
  final Function() constructor;
  final List<Relation> relations;
  final HookModel hooks;
  final ModelBuilder Function()? builder;

  ModelWrapper(this.type, this.tableName, this.modelName, this.constructor, this.relations, this.hooks, this.builder);
}