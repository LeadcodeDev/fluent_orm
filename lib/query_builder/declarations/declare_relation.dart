import 'package:fluent_orm/entities/model.dart';
import 'package:fluent_orm/query_builder/declarations/relation.dart';
import 'package:fluent_orm/query_builder/relations/belong_to.dart';
import 'package:fluent_orm/query_builder/relations/has_many.dart';
import 'package:fluent_orm/query_builder/relations/has_one.dart';
import 'package:fluent_orm/query_builder/relations/many_to_many.dart';
import 'package:pluralize/pluralize.dart';
import 'package:recase/recase.dart';

abstract interface class DeclareRelationContract {
  List<T> hasMany<T extends Model> ();
  T hasOne<T extends Model> ();
  List<T> manyToMany<T extends Model> ();
  T belongTo<T extends Model> ();
}

class DeclareRelation implements DeclareRelationContract {
  final Map<String, dynamic> bucket = {};
  final List<Relation> relations;

  DeclareRelation(this.relations);

  _get<T extends Model, R extends RelationContract> () {
    final tableName = Pluralize().plural(T.toString().snakeCase);
    return bucket['$R::$tableName'];
  }

  @override
  List<T> hasMany<T extends Model> () => _get<T, HasMany>();

  @override
  T hasOne<T extends Model> () => _get<T, HasOne>();

  @override
  List<T> manyToMany<T extends Model> () => _get<T, ManyToMany>();

  @override
  T belongTo<T extends Model> () => _get<T, BelongTo>();
}