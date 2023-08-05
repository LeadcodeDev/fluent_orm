import 'package:fluent_orm/entities/model_wrapper.dart';
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
}