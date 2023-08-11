import 'package:fluent_orm/entities/model.dart';
import 'package:fluent_orm/entities/model_wrapper.dart';
import 'package:fluent_orm/fluent_manager.dart';
import 'package:fluent_orm/query_builder/clause_operator.dart';
import 'package:fluent_orm/query_builder/clauses/and_where_clause.dart';
import 'package:fluent_orm/query_builder/clauses/from_clause.dart';
import 'package:fluent_orm/query_builder/clauses/select_clause.dart';
import 'package:fluent_orm/query_builder/clauses/where_clause.dart';
import 'package:fluent_orm/query_builder/declarations/relation.dart';
import 'package:fluent_orm/query_builder/order.dart';
import 'package:fluent_orm/query_builder/query_builder.dart';

abstract interface class BelongTo implements RelationContract {
  BelongTo select({ List<String> columns });
  BelongTo where({ required String column, String? operator = '=', required dynamic value });
  BelongTo andWhere({ required String column, String? operator = '=', required dynamic value });
  BelongTo orWhere({ required String column, String? operator = '=', required dynamic value });
  BelongTo preload<M extends Model, R extends RelationContract>({ Function(R queryBuilder)? query });
  BelongTo orderBy(String column, { Order direction = Order.asc });
  BelongTo offset(int offset);
  BelongTo limit(int limit);
}

final class BelongToRelation<T extends Model> extends QueryBuilder implements BelongTo {
  final FluentManager _manager;
  final ModelWrapper? _baseModel;
  final ModelWrapper _relatedModel;

  BelongToRelation(this._manager, this._baseModel, this._relatedModel) : super(manager: _manager, model: _relatedModel) {
    final ModelWrapper modelWrapper = _manager.resolve<T>();
    _baseModel?.relations.first.manager = _manager;

    final relation = _baseModel?.relations
      .where((element) => element.relatedModel == modelWrapper)
      .firstOrNull;

    if (relation is! BelongToDeclaration) {
      throw Exception('Relation is not BelongTo');
    }
  }

  Future<dynamic> build(dynamic value) async {
    final selectClause = structure.clauses.select ?? SelectClause(columns: ['*']);

    structure.clauses
      ..select = selectClause
      ..from = FromClause(_relatedModel.tableName)
      ..where.add(structure.clauses.where.isEmpty
        ? WhereClause('id', ClauseOperator.equals, value)
        : AndWhereClause('id', ClauseOperator.equals, value));

    return _manager.request.commit<T, T>(query: _manager.request.buildQuery(structure));
  }
}