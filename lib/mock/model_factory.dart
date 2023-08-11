import 'package:faker/faker.dart';
import 'package:fluent_orm/database.dart';
import 'package:fluent_orm/entities/model_wrapper.dart';
import 'package:fluent_orm/fluent_manager.dart';
import 'package:fluent_orm/mock/structure_factory.dart';

final class ModelFactory<T> {
  late final FluentManager manager;

  static ModelFactory<T> of<T>(FluentManager manager) {
    final factory = ModelFactory<T>();
    factory.manager = manager;

    return factory;
  }

  Future<StructureFactory<T>> make(Function(Faker faker) factory) async {
    final payload = factory(Faker());

    final model = await Database.of(manager)
      .forModel<T>()
      .insert(payload)
      .save();

    return StructureFactory(payload, model);
  }

  Future<List<StructureFactory<T>>> makeMany (int count, Function(Faker faker) factory) async {
    final payload = List<Map<String, dynamic>>.generate(count, (index) => factory(Faker()));

    final elements = await Database.of(manager)
      .forModel<T>()
      .insertMany(payload)
      .saveMany();

    return elements.map((element) {
      final index = elements.indexOf(element);
      return StructureFactory(payload[index], element);
    }).toList();
  }
}