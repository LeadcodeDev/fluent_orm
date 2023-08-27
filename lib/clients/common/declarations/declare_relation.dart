import 'package:fluent_orm/clients/common/declarations/relation.dart';
import 'package:fluent_orm/clients/common/model.dart';
import 'package:pluralize/pluralize.dart';
import 'package:recase/recase.dart';

class DeclareRelation {
  final Map<String, dynamic> bucket = {};
  final List<Relation> relations;

  DeclareRelation(this.relations);

  get<T extends Model, R extends RelationContract> () {
    final tableName = Pluralize().plural(T.toString().snakeCase);
    return bucket['$R::$tableName'];
  }
}