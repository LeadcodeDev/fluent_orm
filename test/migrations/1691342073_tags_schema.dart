import 'package:fluent_orm/schema_builder/schema.dart';

import '../models/tag.dart';

class TagSchema1691342072 extends Schema {
  final String tableName = 'tags';

  @override
  Future<void> up() async {
    schema.createTable(tableName, (table) {
      table.increments('id');
      table.string('label').notNullable();
    });

    schema.defer((database) async {
      await database.forModel<Tag>()
        .insert({ 'label': 'miaou' })
        .save();
    });
  }

  @override
  Future<void> down () async {
    schema.dropTable(tableName);
  }
}