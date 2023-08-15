import 'package:fluent_orm/schema_builder/schema.dart';

class AddFieldArticle1691342072 extends Schema {
  final String tableName = 'articles';

  @override
  Future<void> up() async {
    schema.alterTable(tableName, (table) {
      table.string('title2').nullable();
      table.renameColumn('title2', 'title3');
    });
  }

  @override
  Future<void> down () async {
    schema.alterTable(tableName, (table) {
      table.renameColumn('title3', 'title2');
      table.dropColumn('title2');
    });
  }
}