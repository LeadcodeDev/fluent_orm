import 'package:fluent_orm/entities/model.dart';
import 'package:fluent_orm/entities/model_wrapper.dart';
import 'package:fluent_orm/fluent_manager.dart';
import 'package:fluent_orm/query_builder/clause_operator.dart';
import 'package:fluent_orm/query_builder/clauses/and_where_clause.dart';
import 'package:fluent_orm/query_builder/clauses/from_clause.dart';
import 'package:fluent_orm/query_builder/clauses/select_clause.dart';
import 'package:fluent_orm/query_builder/clauses/where_clause.dart';
import 'package:fluent_orm/query_builder/declarations/relation.dart';
import 'package:fluent_orm/query_builder/query_builder.dart';
import 'package:pluralize/pluralize.dart';

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
    _baseModel?.relations.first.manager = _manager;

    final relation = _baseModel?.relations
      .where((element) => element.relatedModel == modelWrapper)
      .firstOrNull;

    if (relation is! HasManyDeclaration) {
      throw Exception('Relation is not HasMany');
    }
  }

  Future<dynamic> build(dynamic value) async {
    final selectClause = structure.clauses.select ?? SelectClause(columns: ['*']);
    final relatedColumn = Pluralize().singular(_baseModel!.tableName);

    structure.clauses
      ..select = selectClause
      ..from = FromClause(_relatedModel.tableName)
      ..where.add(structure.clauses.where.isEmpty
        ? WhereClause('${relatedColumn}_id', ClauseOperator.equals, value)
        : AndWhereClause('${relatedColumn}_id', ClauseOperator.equals, value));

    return _manager.request.commit<List<T>, T>(query: _manager.request.buildQuery(structure));
  }
}