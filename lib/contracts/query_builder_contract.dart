import 'package:fluent_orm/query_builder/order.dart';

abstract interface class SelectContract<T> {
  SelectContract<T> select({ List<String>? columns });
  SelectContract<T> where({ required String column, String? operator = '=', required dynamic value });
  SelectContract<T> andWhere({ required String column, String? operator = '=', required dynamic value });
  SelectContract<T> orWhere({ required String column, String? operator = '=', required dynamic value });
  SelectContract<T> returning(List<String> columns);
  SelectContract<T> offset(int offset);
  SelectContract<T> limit(int limit);
  SelectContract<T> orderBy(String column, { Order direction = Order.asc });
  Future<List<T>> get();
  Future<T?> first();
  Future<T> firstOrFail();
}

abstract interface class InsertContract<T> {
  Future<T> save();
}

abstract interface class UpdateContract<T> {
  UpdateContract<T> where({ required String column, String? operator = '=', required dynamic value });
  UpdateContract<T> andWhere({ required String column, String? operator = '=', required dynamic value });
  UpdateContract<T> orWhere({ required String column, String? operator = '=', required dynamic value });
  UpdateContract<T> returning(List<String> columns);
  Future<T> put();
}

abstract interface class DeleteContract<T> {
  DeleteContract<T> where({ required String column, String? operator = '=', required dynamic value });
  DeleteContract<T> andWhere({ required String column, String? operator = '=', required dynamic value });
  DeleteContract<T> orWhere({ required String column, String? operator = '=', required dynamic value });
  Future<void> del();
}