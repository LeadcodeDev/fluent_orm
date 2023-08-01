import 'package:fluent_orm/entities/declarations/relation.dart';
import 'package:fluent_orm/entities/model.dart';
import 'package:recase/recase.dart';

abstract interface class DeclareRelationContract {
  List<T> hasMany<T extends Model> ();
  T hasOne<T extends Model> ();
  List<T> manyToMany<T extends Model> ();
}

class DeclareRelation implements DeclareRelationContract {
  final Map<String, dynamic> _bucket = {};
  final List<Relation> _relations;

  DeclareRelation(this._relations);

  _get<T extends Model, R extends RelationContract> () {
    return _bucket['$R::${T.toString().camelCase}'];
  }

  @override
  List<T> hasMany<T extends Model> () => _get<T, HasMany>();

  @override
  T hasOne<T extends Model> () => _get<T, HasOne>();

  @override
  List<T> manyToMany<T extends Model> () => _get<T, ManyToMany>();
}