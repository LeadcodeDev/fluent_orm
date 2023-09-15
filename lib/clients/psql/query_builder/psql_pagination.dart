import 'package:fluent_orm/clients/common/pagination.dart';
import 'package:fluent_orm/clients/common/query_structure.dart';
import 'package:fluent_orm/clients/psql/query_builder/clauses/limit_clause.dart';
import 'package:fluent_orm/clients/psql/query_builder/clauses/offset_clause.dart';
import 'package:fluent_orm/clients/psql/query_builder/psql_clause_structure.dart';
import 'package:fluent_orm/fluent_manager.dart';

final class PsqlPagination<T> extends Pagination<T> {
  final QueryStructure<PsqlClauseStructure> _structure;
  final FluentManager _manager;

  PsqlPagination(this._structure, this._manager, {
    required super.currentPage,
    required super.itemsPerPage,
    required super.firstPage,
    required super.lastPage,
    required super.data,
  });

  @override
  Future<PsqlPagination<T>> previous () async {
    final count = await this.count();
    final page = currentPage - 1;

    if (page < firstPage) {
      return PsqlPagination<T>(_structure, _manager,
        currentPage: page,
        firstPage: firstPage,
        lastPage: _calcLastPage(count),
        itemsPerPage: itemsPerPage,
        data: []
      );
    }

    return _fetchData(page, count);
  }

  @override
  Future<Pagination<T>> next () async {
    final count = await this.count();
    final page = currentPage + 1;

    if (page > lastPage) {
      return PsqlPagination<T>(_structure, _manager,
        currentPage: page,
        firstPage: firstPage,
        lastPage: _calcLastPage(count),
        itemsPerPage: itemsPerPage,
        data: []
      );
    }

    return _fetchData(page, count);
  }

  Future<int> count() async {
    final query = _manager.request.buildSelectQuery(_structure);

    return _manager.request.commit<List>(query)
      .then((value) => value?.length ?? 0);
  }

  Future<PsqlPagination<T>> _fetchData(int targetPage, int count) async {
    _structure.clauses
      ..limit = LimitClause(itemsPerPage)
      ..offset = OffsetClause((targetPage - 1) * itemsPerPage);

    final query = _manager.request.buildSelectQuery(_structure);
    final result = await _manager.request.commit<List>(query);

    _structure.clauses
      ..limit = null
      ..offset = null;

    if (T == dynamic) {
      return PsqlPagination(_structure, _manager,
        currentPage: targetPage,
        firstPage: firstPage,
        lastPage: _calcLastPage(count),
        itemsPerPage: itemsPerPage,
        data: List<T>.from(result ?? []),
      );
    }


    return PsqlPagination<T>(_structure, _manager,
      currentPage: targetPage,
      firstPage: firstPage,
      lastPage: _calcLastPage(count),
      itemsPerPage: itemsPerPage,
      data: List<T>.from(result!.map((element) => _manager.request.assignToModel<T>(element)))
    );
  }

  int _calcLastPage (int count) => (count / itemsPerPage).ceil();
}

// 5 elements
// 2 elements per page
// [x, x] + [x, x] + [x]
