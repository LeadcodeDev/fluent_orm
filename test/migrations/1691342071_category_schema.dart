import 'package:fluent_orm/clients/common/schema.dart';

class CategorySchema1691342071 extends Schema {
  final String tableName = 'categories';

  @override
  Future<void> up () async {
    schema.createTable(tableName, (table) {
      table.increments('id');
      table.string('label').notNullable();
      table.text('description');
    });
  }

  @override
  Future<void> down () async {
    schema.renameTable(tableName, 'categories_backup');
    schema.dropTable(tableName);
  }
}