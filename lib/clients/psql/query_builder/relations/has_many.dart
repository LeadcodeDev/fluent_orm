import 'package:fluent_orm/clients/psql/query_builder/psql_clause_structure.dart';
import 'package:fluent_orm/fluent_manager.dart';
import 'package:fluent_orm/clients/common/abstract_standalone_query_builder.dart';
import 'package:fluent_orm/clients/common/declarations/relation.dart';
import 'package:fluent_orm/clients/common/model.dart';
import 'package:fluent_orm/clients/common/model_wrapper.dart';
import 'package:fluent_orm/clients/common/query_structure.dart';
import 'package:fluent_orm/clients/common/abstract_relation.dart';
import 'package:pluralize/pluralize.dart';

class HasManyRelation<T extends Model> implements AbstractRelation<T> {
  final FluentManager _manager;
  final AbstractStandaloneQueryBuilder<T> _queryBuilder;
  final QueryStructure<PsqlClauseStructure> _structure;
  final ModelWrapper? _baseModel;
  final ModelWrapper _relatedModel;

  HasManyRelation(this._manager, this._queryBuilder, this._structure, this._baseModel, this._relatedModel) {
    final relation = _baseModel?.relations
      .where((element) => element.relatedModel == _relatedModel)
      .firstOrNull;

    if (relation is! HasManyDeclaration) {
      throw Exception('Relation is not HasMany');
    }
  }

  @override
  Future<dynamic> build(dynamic value) async {
    if (_structure.clauses.select == null) {
      _queryBuilder.select(columns: ['*']);
    }

    final relatedColumn = Pluralize().singular(_baseModel!.tableName);

    _queryBuilder
      .from(_relatedModel.tableName)
      .andWhere(column: '${relatedColumn}_${_relatedModel.primaryKey}', value: value);

    final query = _manager.request.buildSelectQuery(_structure);
    final relatedElements = await _manager.request.commit<List>(query)
      .then((elements) => elements!
        .map((element) => _manager.request.assignToModel<T>(element))
        .toList()
      );

    for (final element in relatedElements) {
      await _manager.request.applyPreloads(element, _structure.preloads);
    }

    return relatedElements;
  }
}