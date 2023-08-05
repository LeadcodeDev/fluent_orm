import 'package:fluent_orm/entities/model.dart';
import 'package:fluent_orm/entities/model_wrapper.dart';
import 'package:fluent_orm/fluent_manager.dart';
import 'package:fluent_orm/query_builder/declarations/relation.dart';
import 'package:fluent_orm/query_builder/query_builder.dart';

abstract interface class ManyToMany implements RelationContract {
  ManyToMany select({ List<String>? columns });
  ManyToMany preload<M extends Model, R extends RelationContract>({ Function(R queryBuilder)? query });
}

class ManyToManyRelation<T extends Model> extends QueryBuilder implements ManyToMany {
  final FluentManager _manager;
  final ModelWrapper? _baseModel;
  final ModelWrapper _relatedModel;

  ManyToManyRelation(this._manager, this._baseModel, this._relatedModel): super(manager: _manager, model: _relatedModel) {
    final ModelWrapper modelWrapper = _manager.resolve<T>();
    final relation = _baseModel?.relations
        .where((element) => element.relatedModel == modelWrapper)
        .firstOrNull;

    if (relation is! ManyToManyDeclaration) {
      throw Exception('Relation is not ManyToMany');
    }
  }
}