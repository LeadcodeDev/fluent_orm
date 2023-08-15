import 'package:fluent_orm/schema_builder/schema.dart';

class ArticleTagSchema1691342072 extends Schema {
  final String tableName = 'article_tag';

  @override
  Future<void> up() async {
    schema.createTable(tableName, (table) {
      table.increments('id');
      table.integer('article_id').reference(column: 'id', table: 'articles');
      table.integer('tag_id').reference(column: 'id', table: 'tags');
    });
  }

  @override
  Future<void> down () async {
    schema.dropTable(tableName);
  }
}