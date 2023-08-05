import 'package:fluent_orm/query_builder/clause_token.dart';
import 'package:fluent_orm/query_builder/fragment.dart';
import 'package:fluent_orm/query_builder/fragment_type.dart';

class Clause extends Fragment {
  final ClauseToken token;

  Clause(this.token): super(FragmentType.clause);

  @override
  String get query => token.uid;
}