import 'package:faker/faker.dart';
import 'package:fluent_orm/clients/common/database.dart';
import 'package:fluent_orm/clients/common/model.dart';
import 'package:fluent_orm/fluent_manager.dart';
import 'package:fluent_orm/mock/structure_factory.dart';

final class ModelFactory<T extends Model> {
  late final FluentManager manager;
  dynamic Function(Faker faker) _factory = (Faker faker) {};

  static ModelFactory<T> of<T extends Model>(FluentManager manager) {
    final factory = ModelFactory<T>();
    factory.manager = manager;

    return factory;
  }

  ModelFactory<T> define (Function(Faker faker) factory) {
    _factory = factory;
    return this;
  }

  Future<StructureFactory<T>> make({ Map<String, dynamic>? mergeWith }) async {
    final payload = _factory(Faker());

    final model = await Database.of(manager).model<T>()
      .create({ ...payload, ...?mergeWith });

    return StructureFactory(payload, model);
  }

  Future<List<StructureFactory<T>>> makeMany (int count, { Map<String, dynamic>? mergeWith }) async {
    final payload = List<Map<String, dynamic>>.generate(count, (index) => {
      ..._factory(Faker()),
      ...?mergeWith,
    });

    final elements = await Database.of(manager)
      .model<T>()
      .createMany(payload);

    return elements.map((element) {
      final index = elements.indexOf(element);
      return StructureFactory(payload[index], element);
    }).toList();
  }
}