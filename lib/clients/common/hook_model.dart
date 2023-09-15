import 'package:fluent_orm/clients/common/abstract_standalone_query_builder.dart';

abstract class HookModelContract<T> {
  HookModelContract<T> beforeFetch(Function (AbstractStandaloneQueryBuilder<T>) query);

  /// Add a hook to be executed after the fetch.
  /// You can define your function under the [Model] constructor
  /// ```dart
  /// final class Foo extends Model<Foo> {
  ///   Foo(): super(
  ///     hooks: (hooks) => hooks.afterFetch((models) {
  ///       print(models);
  ///     })
  ///   );
  /// }
  /// ```
  /// Else you can define your functions on static methods
  /// ```dart
  /// final class Foo extends Model<Foo> {
  ///   Foo(): super(
  ///     hooks: (hooks) => hooks.afterFetch(bar)
  ///   );
  ///
  ///   static void bar (List<Foo> models) {
  ///     print(models);
  ///   }
  /// }
  /// ```
  HookModelContract<T> afterFetch(Function (List<T>) model);

  /// Add a hook to be executed before the find.
  /// You can define your function under the [Model] constructor
  /// ```dart
  /// final class Foo extends Model<Foo> {
  ///   Foo(): super(
  ///     hooks: (hooks) => hooks.beforeFind((query) {
  ///       query.where(column: 'id', value: 1);
  ///     })
  ///   );
  /// }
  /// ```
  /// Else you can define your functions on static methods
  /// ```dart
  /// final class Foo extends Model<Foo> {
  ///   Foo(): super(
  ///     hooks: (hooks) => hooks.beforeFind(bar)
  ///   );
  ///
  ///   static void bar (AbstractStandaloneQueryBuilder<Foo> query) {
  ///     query.where(column: 'id', value: 1);
  ///   }
  /// }
  /// ```
  HookModelContract<T> beforeFind(Function (AbstractStandaloneQueryBuilder<T>) query);

  /// Add a hook to be executed after the find.
  /// You can define your function under the [Model] constructor
  /// ```dart
  /// final class Foo extends Model<Foo> {
  ///   Foo(): super(
  ///     hooks: (hooks) => hooks.afterFind((model) {
  ///       print(model);
  ///     })
  ///   );
  /// }
  /// ```
  ///
  /// Else you can define your functions on static methods
  /// ```dart
  /// final class Foo extends Model<Foo> {
  ///   Foo(): super(
  ///     hooks: (hooks) => hooks.afterFind(bar)
  ///   );
  ///
  ///   static void bar (Foo model) {
  ///     print(model);
  ///   }
  /// }
  /// ```
  HookModelContract<T> afterFind(Function (T) model);

  /// Add a hook to be executed before the create action.
  /// You can define your function under the [Model] constructor
  /// ```dart
  /// final class Foo extends Model<Foo> {
  ///   Foo(): super(
  ///     hooks: (hooks) => hooks.beforeCreate((model) {
  ///       print(model);
  ///     })
  ///   );
  /// }
  /// ```
  ///
  /// Else you can define your functions on static methods
  /// ```dart
  /// final class Foo extends Model<Foo> {
  ///   Foo(): super(
  ///     hooks: (hooks) => hooks.beforeCreate(bar)
  ///   );
  ///
  ///   static void bar (Function(Map<String, dynamic>) model) {
  ///     print(model);
  ///   }
  /// }
  /// ```
  HookModelContract<T> beforeCreate(Function(Map<String, dynamic>) model);

  /// Add a hook to be executed after the create action.
  /// You can define your function under the [Model] constructor
  /// ```dart
  /// final class Foo extends Model<Foo> {
  ///   Foo(): super(
  ///     hooks: (hooks) => hooks.afterCreate((model) {
  ///       print(model);
  ///     })
  ///   );
  /// }
  /// ```
  ///
  /// Else you can define your functions on static methods
  /// ```dart
  /// final class Foo extends Model<Foo> {
  ///   Foo(): super(
  ///     hooks: (hooks) => hooks.afterCreate(bar)
  ///   );
  ///
  ///   static void bar (Foo model) {
  ///     print(model);
  ///   }
  /// }
  /// ```
  HookModelContract<T> afterCreate(Function (T) model);

  /// Add a hook to be executed before the save action.
  /// You can define your function under the [Model] constructor
  /// ```dart
  /// final class Foo extends Model<Foo> {
  ///   Foo(): super(
  ///     hooks: (hooks) => hooks.beforeSave((model) {
  ///       print(model);
  ///     })
  ///   );
  /// }
  /// ```
  ///
  /// Else you can define your functions on static methods
  /// ```dart
  /// final class Foo extends Model<Foo> {
  ///   Foo(): super(
  ///     hooks: (hooks) => hooks.beforeSave(bar)
  ///   );
  ///
  ///   static void bar (Function(Map<String, dynamic>) model) {
  ///     print(model);
  ///   }
  /// }
  /// ```
  HookModelContract<T> beforeSave(Function(Map<String, dynamic>) model);

  /// Add a hook to be executed after the save action.
  /// You can define your function under the [Model] constructor
  /// ```dart
  /// final class Foo extends Model<Foo> {
  ///   Foo(): super(
  ///     hooks: (hooks) => hooks.afterSave((model) {
  ///       print(model);
  ///     })
  ///   );
  /// }
  /// ```
  ///
  /// Else you can define your functions on static methods
  /// ```dart
  /// final class Foo extends Model<Foo> {
  ///   Foo(): super(
  ///     hooks: (hooks) => hooks.afterSave(bar)
  ///   );
  ///
  ///   static void bar (Foo model) {
  ///     print(model);
  ///   }
  /// }
  /// ```
  HookModelContract<T> afterSave(Function (T) model);

  /// Add a hook to be executed before the delete action.
  /// You can define your function under the [Model] constructor
  /// ```dart
  /// final class Foo extends Model<Foo> {
  ///   Foo(): super(
  ///     hooks: (hooks) => hooks.beforeDelete((model) {
  ///       print(model);
  ///     })
  ///   );
  /// }
  /// ```
  ///
  /// Else you can define your functions on static methods
  /// ```dart
  /// final class Foo extends Model<Foo> {
  ///   Foo(): super(
  ///     hooks: (hooks) => hooks.beforeDelete(bar)
  ///   );
  ///
  ///   static void bar (AbstractStandaloneQueryBuilder<Foo> model) {
  ///     print(model);
  ///   }
  /// }
  /// ```
  HookModelContract<T> beforeDelete(Function (AbstractStandaloneQueryBuilder<T>) query);

  /// Add a hook to be executed after the delete action.
  /// You can define your function under the [Model] constructor
  /// ```dart
  /// final class Foo extends Model<Foo> {
  ///   Foo(): super(
  ///     hooks: (hooks) => hooks.afterDelete((model) {
  ///       print(model);
  ///     })
  ///   );
  /// }
  /// ```
  ///
  /// Else you can define your functions on static methods
  /// ```dart
  /// final class Foo extends Model<Foo> {
  ///   Foo(): super(
  ///     hooks: (hooks) => hooks.afterDelete(bar)
  ///   );
  ///
  ///   static void bar () {
  ///     print('deleted');
  ///   }
  /// }
  /// ```
  HookModelContract<T> afterDelete();
}

final class HookModel<T> implements HookModelContract<T> {
  final List<void Function(AbstractStandaloneQueryBuilder<T> query)> beforeFetchHooks = [];
  final List<void Function(List<T>)> afterFetchHooks = [];

  final List<void Function(AbstractStandaloneQueryBuilder<T> query)> beforeFindHooks = [];
  final List<void Function(T)> afterFindHooks = [];

  final List<void Function(Map<String, dynamic> model)> beforeCreateHooks = [];
  final List<void Function(T)> afterCreateHooks = [];

  final List<void Function(Map<String, dynamic> query)> beforeSaveHooks = [];
  final List<void Function(T)> afterSaveHooks = [];

  final List<void Function(AbstractStandaloneQueryBuilder<T> query)> beforeDeleteHooks = [];
  final List<void Function()> afterDeleteHooks = [];

  @override
  HookModelContract<T> beforeFetch(Function(AbstractStandaloneQueryBuilder<T>) query) {
    beforeFetchHooks.add(query);
    return this;
  }

  @override
  HookModelContract<T> afterFetch(Function(List<T>) models) {
    afterFetchHooks.add(models);
    return this;
  }

  @override
  HookModelContract<T> beforeFind(Function(AbstractStandaloneQueryBuilder<T>) query) {
    beforeFindHooks.add(query);
    return this;
  }

  @override
  HookModelContract<T> afterFind(Function(T) model) {
    afterFindHooks.add(model);
    return this;
  }

  @override
  HookModelContract<T> beforeCreate(Function(Map<String, dynamic>) model) {
    beforeCreateHooks.add(model);
    return this;
  }

  @override
  HookModelContract<T> afterCreate(Function(T) model) {
    afterCreateHooks.add(model);
    return this;
  }

  @override
  HookModelContract<T> beforeSave(Function(Map<String, dynamic>) model) {
    beforeSaveHooks.add(model);
    return this;
  }

  @override
  HookModelContract<T> afterSave(Function(T) model) {
    afterSaveHooks.add(model);
    return this;
  }

  @override
  HookModelContract<T> beforeDelete(Function(AbstractStandaloneQueryBuilder<T>) query) {
    beforeDeleteHooks.add(query);
    return this;
  }

  @override
  HookModelContract<T> afterDelete() {
    afterDeleteHooks.add(() {});
    return this;
  }
}