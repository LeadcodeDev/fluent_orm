import 'package:fluent_orm/clients/psql/query_builder/psql_clause_structure.dart';
import 'package:fluent_orm/fluent_manager.dart';
import 'package:fluent_orm/clients/common/abstract_standalone_query_builder.dart';
import 'package:fluent_orm/clients/common/declarations/relation.dart';
import 'package:fluent_orm/clients/common/model.dart';
import 'package:fluent_orm/clients/common/model_wrapper.dart';
import 'package:fluent_orm/clients/common/query_structure.dart';
import 'package:fluent_orm/clients/psql/query_builder/relations/abstract_relation.dart';

final class BelongToRelation<T extends Model> implements AbstractRelation<T> {
  final FluentManager _manager;
  final AbstractStandaloneQueryBuilder<T> _queryBuilder;
  final QueryStructure<PsqlClauseStructure> _structure;
  final ModelWrapper? _baseModel;
  final ModelWrapper _relatedModel;

  BelongToRelation(this._manager, this._queryBuilder, this._structure, this._baseModel, this._relatedModel) {
    final ModelWrapper modelWrapper = _manager.resolve<T>();
    final relation = _baseModel?.relations
      .where((element) => element.relatedModel == modelWrapper)
      .firstOrNull;

    if (relation is! BelongToDeclaration) {
      throw Exception('Relation is not BelongTo');
    }
  }

  @override
  Future<dynamic> build(dynamic value) async {
    if (_structure.clauses.select == null) {
      _queryBuilder.select(columns: ['*']);
    }

    _queryBuilder
      .from(_relatedModel.tableName)
      .andWhere(column: _relatedModel.primaryKey, value: value);

    final query = _manager.request.buildSelectQuery(_structure);
    final relatedElement = await _manager.request.commit<dynamic>(query);
    final model = _manager.request.assignToModel<T>(relatedElement);

    await _manager.request.applyPreloads(model, _structure.preloads);

    return model;
  }
}