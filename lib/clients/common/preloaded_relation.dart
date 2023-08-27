import 'package:fluent_orm/clients/common/declarations/relation.dart';
import 'package:fluent_orm/clients/common/model.dart';

class PreloadRelation<T extends Model, R extends RelationContract> {
  final Future Function(dynamic value) query;
  final Type relationType;
  final Type modelType;

  PreloadRelation(this.query, this.modelType, this.relationType);
}