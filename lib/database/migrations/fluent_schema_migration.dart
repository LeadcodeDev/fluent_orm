import 'package:fluent_orm/clients/common/schema.dart';

class FluentSchemaMigration extends Schema {
  final String tableName = 'fluent_schemas';

  @override
  Future<void> up() async{
    schema.createTable(tableName, (table) {
      table.increments('id');
      table.string('name').notNullable();
      table.integer('batch').notNullable();
      table.timestamp('migration_time').notNullable();
    });
  }

  @override
  Future<void> down() async {
    schema.dropTable(tableName);
  }
}