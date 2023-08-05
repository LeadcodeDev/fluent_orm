import 'package:fluent_orm/entities/model.dart';
import 'package:fluent_orm/entities/model_wrapper.dart';
import 'package:fluent_orm/fluent_manager.dart';
import 'package:fluent_orm/query_builder/declarations/relation.dart';

class PreloadRelation<T extends Model, R extends RelationContract> {
  final FluentManager _manager;
  final Future Function(dynamic value) query;
  final Type type;

  PreloadRelation(this._manager, this.query, this.type);

  ModelWrapper get relation => _manager.resolve<T>();
}