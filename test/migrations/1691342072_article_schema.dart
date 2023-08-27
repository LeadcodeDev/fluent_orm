import 'package:fluent_orm/database/schema.dart';

class ArticleSchema1691342072 extends Schema {
  final String tableName = 'articles';

  @override
  Future<void> up() async {
    schema.createTable(tableName, (table) {
      table.increments('id');
      table.string('title').notNullable();
      table.text('content');
      table.integer('category_id').reference(column: 'id', table: 'categories');
    });
  }

  @override
  Future<void> down () async {
    schema.dropTable(tableName);
  }
}