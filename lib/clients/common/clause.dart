import 'package:fluent_orm/clients/common/fragment.dart';
import 'package:fluent_orm/clients/common/fragment_type.dart';

class Clause extends Fragment {
  final String token;

  Clause(this.token): super(FragmentType.clause);

  @override
  String get query => token;
}