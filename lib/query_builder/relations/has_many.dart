import 'package:fluent_orm/entities/model.dart';
import 'package:fluent_orm/entities/model_wrapper.dart';
import 'package:fluent_orm/fluent_manager.dart';
import 'package:fluent_orm/query_builder/declarations/relation.dart';
import 'package:fluent_orm/query_builder/query_builder.dart';

abstract interface class HasMany implements RelationContract {
  HasMany select({ List<String>? columns });
  HasMany preload<M extends Model, R extends RelationContract>({ Function(R queryBuilder)? query });
}

class HasManyRelation<T extends Model> extends QueryBuilder {
  final FluentManager _manager;
  final ModelWrapper? _baseModel;
  final ModelWrapper _relatedModel;

  HasManyRelation(this._manager, this._baseModel, this._relatedModel) : super(manager: _manager, model: _relatedModel) {
    final ModelWrapper modelWrapper = _manager.resolve<T>();
    final relation = _baseModel?.relations
      .where((element) => element.relatedModel == modelWrapper)
      .firstOrNull;

    if (relation is! HasManyDeclaration) {
      throw Exception('Relation is not HasMany');
    }
  }
}