import 'package:fluent_orm/clients/common/hook_model.dart';
import 'package:fluent_orm/clients/common/declarations/relation.dart';

class ModelWrapper {
  final Type type;
  final String primaryKey;
  final String modelName;
  final String tableName;
  final Function() constructor;
  final List<Relation> relations;
  final HookModel hooks;

  ModelWrapper(this.type, this.primaryKey, this.tableName, this.modelName, this.constructor, this.relations, this.hooks);
}