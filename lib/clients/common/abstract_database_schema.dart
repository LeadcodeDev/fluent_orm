import 'package:fluent_orm/clients/common/database.dart';
import 'package:fluent_orm/clients/common/abstract_alter_table.dart';
import 'package:fluent_orm/clients/common/abstract_create_table.dart';

abstract class AbstractDatabaseSchema {
  Future createTable (String tableName, Function(AbstractCreateTable table) schema);
  Future<void> alterTable (String tableName, Function(AbstractAlterTable table) schema);
  Future<void> renameTable (String tableName, String newName);
  Future<void> dropTable (String tableName);
  void defer (Future<void> Function(Database manager) callback);
}