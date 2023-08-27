import 'package:fluent_orm/clients/common/database.dart';
import 'package:fluent_orm/fluent_manager.dart';
import 'package:fluent_orm/clients/common/declarations/relation.dart';
import 'package:fluent_orm/clients/common/model.dart';
import 'package:fluent_orm/clients/common/model_wrapper.dart';
import 'package:pluralize/pluralize.dart';

class RelatedModel<T, M extends Model, R extends RelationContract> {
  final FluentManager _manager;
  final Model _baseModel;
  final ModelWrapper _relatedModel;

  RelatedModel(this._manager, this._baseModel, this._relatedModel);

  List<String> get pivotNames => [
    Pluralize().singular(_baseModel.model.metadata.tableName),
    Pluralize().singular(_relatedModel.tableName)
  ]..sort();

  Future<void> associate (Iterable ids) async {
    if (R != ManyToMany) {
      throw Exception('Relation is not ManyToMany');
    }

    final baseModelKey = '${Pluralize().singular(_baseModel.model.metadata.tableName)}_id';
    final relatedModelKey = '${Pluralize().singular(_relatedModel.tableName)}_id';

    final payload = ids.map((e) => {
      baseModelKey: _baseModel.model.property('id'),
      relatedModelKey: e
    });

    await Database.of(_manager).query()
      .table(pivotNames.join('_'))
      .insertMany(payload.toList());
  }

  Future<void> dissociate (Iterable ids) async {
    if (R != ManyToMany) {
      throw Exception('Relation is not ManyToMany');
    }

    final relatedModelKey = '${Pluralize().singular(_relatedModel.tableName)}_id';

    await Database.of(_manager).query()
      .from(pivotNames.join('_'))
      .whereIn(column: relatedModelKey, values: ids.toList())
      .del();
  }

  Future<M> create (Map<String, dynamic> payload) async {
    if (R != HasMany) {
      throw Exception('Relation is not HasMany');
    }

    final relatedKey = '${Pluralize().singular(_baseModel.model.metadata.tableName)}_id';
    return Database.of(_manager).model<M>()
      .create({ ...payload, relatedKey: _baseModel.model.property('id') });
  }
}