import 'package:fluent_orm/clients/common/schema.dart';

class TagSchema1691342072 extends Schema {
  final String tableName = 'tags';

  @override
  Future<void> up() async {
    schema.createTable(tableName, (table) {
      table.increments('id');
      table.string('label').notNullable();
    });
  }

  @override
  Future<void> down () async {
    schema.dropTable(tableName);
  }
}