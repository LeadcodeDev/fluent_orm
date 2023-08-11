import 'package:fluent_orm/schema_builder/schema.dart';

class FluentSchemaMigration extends Schema {
  @override
  Future<void> up() async{
    schema.createTable('fluent_schemas', (table) {
      table.increments('id');
      table.string('name').notNullable();
      table.integer('batch').notNullable();
      table.timestamp('migration_time').notNullable();
    });
  }

  @override
  Future<void> down() async {

  }
}