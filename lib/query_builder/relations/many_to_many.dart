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
import 'package:fluent_orm/query_builder/query_structure.dart';

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

  Future<List<T>> build(dynamic value) async {
    final pivots = await _getPivotRelation(value);
    final selectClause = structure.clauses.select ?? SelectClause(columns: ['*']);

    structure.clauses.select = selectClause;

    final List<T> relatedModels = [];
    for (final pivot in pivots) {
      final models = await _getRelatedValues(pivot: pivot, columns: selectClause.columns);
      relatedModels.addAll(models);
    }

    return relatedModels;
  }

  Future<List<Map>> _getPivotRelation (dynamic value) async {
    final List<String> models = [_baseModel!.tableName, _relatedModel.tableName]..sort();

    final queryStructure = QueryStructure()
      ..clauses.select = SelectClause(columns: ['*'])
      ..clauses.from = FromClause(models.join('_'))
      ..clauses.where.add(WhereClause('${_baseModel!.tableName}_id', ClauseOperator.equals, value));

    final query = _manager.request.buildQuery(queryStructure);
    return _manager.request.commitPivot(query);
  }

  Future<List<T>> _getRelatedValues ({ required Map pivot, List<String>? columns }) async {
    final pivotValue = pivot['${_relatedModel.tableName}_id'];

    final queryStructure = QueryStructure()
      ..clauses.select = SelectClause(columns: columns ?? ['*'])
      ..clauses.from = FromClause(_relatedModel.tableName)
      ..clauses.where.add(structure.clauses.where.isEmpty
          ? WhereClause('id', ClauseOperator.equals, pivotValue)
          : AndWhereClause('id', ClauseOperator.equals, pivotValue));


    final query = _manager.request.buildQuery(queryStructure);
    return await _manager.request.commit<List<T>, T>(preloads: queryStructure.preloads, query: query);
  }
}