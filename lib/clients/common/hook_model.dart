
final class HookModel<T extends dynamic> {
  late final List<Future<void> Function(T)> beforeCreate;
  late final List<Future<void> Function(T)> beforeSave;
  late final List<Future<void> Function(T)> beforeDelete;

  HookModel({
    this.beforeCreate = const [],
    this.beforeSave = const [],
    this.beforeDelete = const []
  });
}