import 'package:fluent_orm/schema_builder/column_modifier.dart';

class UniqueModifier extends ColumnModifier {
  final String? _relatedColumn;

  UniqueModifier(this._relatedColumn): super('UNIQUE');

  @override
  String get query => [token, _relatedColumn != null
    ? '($_relatedColumn)'
    : null
  ].nonNulls.join(' ') ;
}