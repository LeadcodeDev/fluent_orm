import 'package:fluent_orm/entities/clause_token.dart';
import 'package:fluent_orm/entities/fragment.dart';
import 'package:fluent_orm/entities/fragment_type.dart';

class Clause extends Fragment {
  final ClauseToken token;

  Clause(this.token): super(FragmentType.clause);

  @override
  String get query => token.uid;
}