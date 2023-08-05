import 'package:fluent_orm/query_builder/fragment_type.dart';

abstract class Fragment {
  final FragmentType type;
  String get query;

  Fragment(this.type);
}