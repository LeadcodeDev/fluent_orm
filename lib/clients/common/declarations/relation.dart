import 'package:fluent_orm/fluent_manager.dart';
import 'package:fluent_orm/clients/common/model.dart';
import 'package:fluent_orm/clients/common/model_wrapper.dart';

abstract class RelationContract<T extends Model> {}
abstract interface class ManyToMany implements RelationContract {}
abstract interface class HasMany implements RelationContract {}
abstract interface class HasOne implements RelationContract {}
abstract interface class BelongTo implements RelationContract {}

final class HasManyDeclaration<M extends Model> extends Relation<M> {
  HasManyDeclaration(super._localKey, super._foreignKey);

  @override
  String get localKey => _localKey ?? '${relatedModel.tableName}_id';

  @override
  String get foreignKey => _foreignKey ?? 'id';
}

final class HasOneDeclaration<M extends Model> extends Relation<M> {
  HasOneDeclaration(super._localKey, super._foreignKey);

  @override
  String get localKey => _localKey ?? '${relatedModel.tableName}_id';

  @override
  String get foreignKey => _foreignKey ?? 'id';
}

final class ManyToManyDeclaration<M extends Model> extends Relation<M> {
  final String? _pivotForeignKey;
  final String? _pivotRelatedForeignKey;

  ManyToManyDeclaration(String? localKey, String? foreignKey, this._pivotForeignKey, this._pivotRelatedForeignKey): super(localKey, foreignKey);

  String get pivotForeignKey => _pivotForeignKey ?? '';
  String get pivotRelatedForeignKey => _pivotRelatedForeignKey ?? '';

  @override
  String get localKey => _localKey ?? '${relatedModel.tableName}_id';

  @override
  String get foreignKey => _foreignKey ?? 'id';
}

final class BelongToDeclaration<M extends Model> extends Relation<M> {
  BelongToDeclaration(super._localKey, super._foreignKey);

  @override
  String get localKey => _localKey ?? '${relatedModel.tableName}_id';

  @override
  String get foreignKey => _foreignKey ?? 'id';
}

sealed class Relation<M extends Model> {
  late final FluentManager manager;

  final String? _localKey;
  final String? _foreignKey;

  Relation(this._localKey, this._foreignKey);

  String get localKey => _localKey ?? '';
  String get foreignKey => _foreignKey ?? '';

  ModelWrapper get relatedModel => manager.resolve<M>();

  factory Relation.hasMany({ String? localKey, String? foreignKey }) => HasManyDeclaration<M>(localKey, foreignKey);
  factory Relation.hasOne({ String? localKey, String? foreignKey }) => HasOneDeclaration<M>(localKey, foreignKey);
  factory Relation.manyToMany({ String? localKey, String? foreignKey, String? pivotForeignKey, String? pivotRelatedForeignKey }) => ManyToManyDeclaration<M>(localKey, foreignKey, pivotForeignKey, pivotRelatedForeignKey);
  factory Relation.belongTo({ String? localKey, String? foreignKey }) => BelongToDeclaration<M>(localKey, foreignKey);
}