import 'package:fluent_orm/clients/common/fragment_type.dart';

abstract class Fragment {
  final FragmentType type;
  String get query;

  Fragment(this.type);
}