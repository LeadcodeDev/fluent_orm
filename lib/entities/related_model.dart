import 'package:fluent_orm/database.dart';
import 'package:fluent_orm/entities/model.dart';
import 'package:fluent_orm/entities/model_wrapper.dart';
import 'package:fluent_orm/fluent_manager.dart';
import 'package:fluent_orm/query_builder/declarations/relation.dart';
import 'package:fluent_orm/query_builder/relations/has_many.dart';
import 'package:fluent_orm/query_builder/relations/many_to_many.dart';
import 'package:pluralize/pluralize.dart';

class RelatedModel<T, M extends Model, R extends RelationContract> {
  final FluentManager _manager;
  final Model _baseModel;
  final ModelWrapper _relatedModel;

  RelatedModel(this._manager, this._baseModel, this._relatedModel);

  Future<void> associate (Iterable ids) async {
    if (R != ManyToMany) {
      throw Exception('Relation is not ManyToMany');
    }

    final List<String> pivotName = [
      Pluralize().singular(_baseModel.metadata.tableName),
      Pluralize().singular(_relatedModel.tableName)
    ]..sort();

    final baseModelKey = '${Pluralize().singular(_baseModel.metadata.tableName)}_id';
    final relatedModelKey = '${Pluralize().singular(_relatedModel.tableName)}_id';

    final payload = ids.map((e) => {
      baseModelKey: _baseModel.properties.get('id'),
      relatedModelKey: e
    });

    await Database.of(_manager).query()
      .into(pivotName.join('_'))
      .insertMany(payload.toList())
      .saveMany();
  }

  Future<M> create (Map<String, dynamic> payload) async {
    if (R != HasMany) {
      throw Exception('Relation is not HasMany');
    }

    final relatedKey = '${Pluralize().singular(_baseModel.metadata.tableName)}_id';
    return Database.of(_manager).forModel<M>()
      .insert({ ...payload, relatedKey: _baseModel.properties.get('id') })
      .save();
  }
}