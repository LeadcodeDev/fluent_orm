import 'package:fluent_orm/clients/psql/query_builder/psql_clause_structure.dart';
import 'package:fluent_orm/fluent_manager.dart';
import 'package:fluent_orm/clients/common/abstract_standalone_query_builder.dart';
import 'package:fluent_orm/clients/psql/query_builder/clauses/from_clause.dart';
import 'package:fluent_orm/clients/psql/query_builder/clauses/select_clause.dart';
import 'package:fluent_orm/clients/psql/query_builder/clauses/where_clause.dart';
import 'package:fluent_orm/clients/common/declarations/relation.dart';
import 'package:fluent_orm/clients/common/model.dart';
import 'package:fluent_orm/clients/common/model_wrapper.dart';
import 'package:fluent_orm/clients/common/query_structure.dart';
import 'package:fluent_orm/clients/psql/query_builder/relations/abstract_relation.dart';
import 'package:pluralize/pluralize.dart';

class ManyToManyRelation<T extends Model> implements AbstractRelation<T> {
  final FluentManager _manager;
  final AbstractStandaloneQueryBuilder<T> _queryBuilder;
  final QueryStructure<PsqlClauseStructure> _structure;
  final ModelWrapper? _baseModel;
  final ModelWrapper _relatedModel;

  ManyToManyRelation(this._manager, this._queryBuilder, this._structure, this._baseModel, this._relatedModel) {
    final ModelWrapper modelWrapper = _manager.resolve<T>();
    final relation = _baseModel?.relations
      .where((element) => element.relatedModel == modelWrapper)
      .firstOrNull;

    if (relation is! ManyToManyDeclaration) {
      throw Exception('Relation is not ManyToMany');
    }
  }

  @override
  Future<List<T>> build(dynamic value) async {
    final Pluralize pluralize = Pluralize();
    final String relatedKey = '${pluralize.singular(_relatedModel.tableName)}_${_relatedModel.primaryKey}';

    final pivots = await _getPivotRelation(value)
      .then((pivots) => pivots.map((pivot) => pivot[relatedKey])
      .toList());

    if (pivots.isEmpty) {
      return [];
    }

    if (_structure.clauses.select == null) {
      _queryBuilder.select(columns: ['*']);
    }

    _queryBuilder
      .from(_relatedModel.tableName)
      .whereIn(column: _relatedModel.primaryKey, values: pivots);

    final query = _manager.request.buildSelectQuery(_structure);
    final relatedElement = await _manager.request.commit<List>(query);

    final models = relatedElement!
      .map((element) => _manager.request.assignToModel<T>(element))
      .toList();

    for (final model in models) {
      await _manager.request.applyPreloads(model, _structure.preloads);
    }

    return models;
  }

  Future<List<dynamic>> _getPivotRelation (dynamic value) async {
    final pluralize = Pluralize();
    final List<String> models = [
      pluralize.singular(_baseModel!.tableName),
      pluralize.singular(_relatedModel.tableName)
    ]..sort();

    final queryStructure = QueryStructure<PsqlClauseStructure>(PsqlClauseStructure())
      ..clauses.select = SelectClause(['*'])
      ..clauses.from = FromClause(models.join('_'))
      ..clauses.where.add(WhereClause('${pluralize.singular(_baseModel!.tableName)}_${_baseModel?.primaryKey}', '=', value));

    final query = _manager.request.buildSelectQuery(queryStructure);
    final result = await _manager.request.commit<List>(query);

    return result!;
  }
}