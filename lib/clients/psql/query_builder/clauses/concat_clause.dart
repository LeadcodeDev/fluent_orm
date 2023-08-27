import 'package:fluent_orm/clients/common/clause.dart';

class ConcatClause extends Clause {
  final List<String> elements;
  final String separator;

  ConcatClause(this.elements, this.separator): super('CONCAT');

  @override
  String get query {
    final String concat = elements.join(separator);
    return '$token($concat)';
  }
}