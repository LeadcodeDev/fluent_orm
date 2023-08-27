import 'package:fluent_orm/clients/common/fragment.dart';
import 'package:fluent_orm/clients/common/fragment_type.dart';

class Punctuation extends Fragment {
  final String token;

  Punctuation(this.token) : super(FragmentType.punctuation);

  @override
  String get query => token;
}