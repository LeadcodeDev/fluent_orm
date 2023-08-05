import 'package:fluent_orm/query_builder/fragment.dart';
import 'package:fluent_orm/query_builder/fragment_type.dart';

class Punctuation extends Fragment {
  final String token;

  Punctuation(this.token) : super(FragmentType.punctuation);

  @override
  String get query => token;
}