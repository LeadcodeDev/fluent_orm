import 'package:fluent_orm/clients/common/database.dart';
import 'package:fluent_orm/fluent_manager.dart';
import 'package:fluent_orm/clients/common/hook_model.dart';
import 'package:fluent_orm/clients/common/declarations/declare_metadata.dart';
import 'package:fluent_orm/clients/common/declarations/declare_relation.dart';
import 'package:fluent_orm/clients/common/declarations/relation.dart';
import 'package:fluent_orm/clients/common/related_model.dart';

abstract class InternalModelContract {
  dynamic property(String key);

  List<T> hasMany<T extends Model>();
  T hasOne<T extends Model>();
  List<T> manyToMany<T extends Model>();
  T belongTo<T extends Model>();

  late final DeclareMetadataContract metadata;
}

class InternalModel implements InternalModelContract {
  final Map<String, dynamic> bucket = {};

  late final FluentManager manager;
  late DeclareRelation relations;

  late final HookModel hooks;

  @override
  late final DeclareMetadataContract metadata;

  @override
  dynamic property(String key) => bucket[key];

  @override
  List<T> hasMany<T extends Model> () => relations.get<T, HasMany>();

  @override
  T hasOne<T extends Model> () => relations.get<T, HasOne>();

  @override
  List<T> manyToMany<T extends Model> () => relations.get<T, ManyToMany>();

  @override
  T belongTo<T extends Model> () => relations.get<T, BelongTo>();
}

abstract class Model<T> {
  late final InternalModelContract model;

  String get primaryKey => 'id';

  Model({ List<Relation>? relations, void Function (HookModelContract<T>)? hooks }) {
    final hookModel = HookModel();

    if (hooks != null) {
      hooks(hookModel as HookModelContract<T>);
    }

    this.model = InternalModel()
      ..relations = DeclareRelation(relations ?? [])
      ..hooks = hookModel;
  }

  int get id => model.property(primaryKey);

  RelatedModel<T, M, R> related<M extends Model, R extends RelationContract> () {
    final internalModel = model as InternalModel;
    return RelatedModel<T, M, R>(internalModel.manager, this, internalModel.manager.resolve<M>());
  }

  Future<T> update (Map<String, String> payload) async {
    final internalModel = model as InternalModel;

    final query = Database.of(internalModel.manager).model<T>().query()
      .table(model.metadata.tableName)
      .where(column: 'id', value: model.property('id'))
      .returning(['*']);

    for (final hook in internalModel.hooks.beforeSaveHooks) {
      hook(payload);
    }

    return query.update(payload).then((value) {
      for (final hook in internalModel.hooks.afterSaveHooks) {
        hook(query);
      }

      return value;
    });
  }

  Future<void> delete () async {
    final internalModel = model as InternalModel;

    final query = Database.of(internalModel.manager).model<T>().query()
      .where(column: 'id', value: model.property('id'));

    for (final hook in internalModel.hooks.beforeDeleteHooks) {
      hook(query);
    }

    return query.del().then((value) {
      for (final hook in internalModel.hooks.afterDeleteHooks) {
        hook();
      }

      return value;
    });
  }
}