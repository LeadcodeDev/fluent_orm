
final class HookModel<T extends dynamic> {
  late final dynamic beforeCreate;
  late final dynamic beforeSave;
  late final dynamic beforeDelete;

  HookModel({ void Function(T)? beforeCreate, void Function(T)? beforeSave, void Function(T)? beforeDelete }) {
    this.beforeCreate = beforeCreate ?? (dynamic builder) {};
    this.beforeSave = beforeSave ?? (dynamic builder) {};
    this.beforeDelete = beforeDelete ?? (dynamic builder) {};
  }
}