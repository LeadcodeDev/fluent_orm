import 'package:fluent_orm/clients/common/clause.dart';

class SetClause extends Clause {
  final Map<String, dynamic> values;

  SetClause(this.values): super('SET');

  @override
  String get query => [token, values.entries.fold([], (acc, element) => [...acc, '${element.key} = \'${element.value}\'']).join(', ')].join(' ');
}