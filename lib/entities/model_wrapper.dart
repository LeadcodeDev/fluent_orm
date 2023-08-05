import 'package:fluent_orm/query_builder/declarations/relation.dart';

class ModelWrapper {
  final Type type;
  final String modelName;
  final String tableName;
  final Function() constructor;
  final List<String> fields;
  final List<Relation> relations;

  ModelWrapper(this.type, this.tableName, this.modelName, this.constructor, this.fields, this.relations);
}