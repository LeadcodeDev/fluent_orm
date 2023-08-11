import 'package:fluent_orm/database.dart';
import 'package:fluent_orm/entities/model_wrapper.dart';
import 'package:fluent_orm/entities/related_model.dart';
import 'package:fluent_orm/fluent_manager.dart';
import 'package:fluent_orm/query_builder/declarations/declare_metadata.dart';
import 'package:fluent_orm/query_builder/declarations/declare_property.dart';
import 'package:fluent_orm/query_builder/declarations/declare_relation.dart';
import 'package:fluent_orm/query_builder/declarations/relation.dart';

class Model<T> {
  late final FluentManager manager;
  ModelWrapper get _model => manager.resolve<T>();

  late DeclareRelationContract relations;
  late DeclarePropertyContract properties;
  late DeclareMetadataContract metadata = DeclareMetadata();

  Model({ List<Relation>? relations, List<String>? properties }) {
    this.relations = DeclareRelation(relations ?? []);
    this.properties = DeclareProperty(properties ?? []);
  }

  RelatedModel<T, M, R> related<M extends Model, R extends RelationContract> () {
    return RelatedModel<T, M, R>(manager, this, manager.resolve<M>());
  }

  Future<T> update (Map<String, String> payload) async {
    return Database.of(manager).forModel<T>()
      .update(payload)
      .where(column: 'id', value: properties.get('id'))
      .returning(_model.fields)
      .put();
  }

  Future<void> delete () async {
    return Database.of(manager).forModel<T>()
      .where(column: 'id', value: properties.get('id'))
      .del();
  }
}