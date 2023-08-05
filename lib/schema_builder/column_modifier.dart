abstract class ColumnModifier {
  final String token;
  const ColumnModifier(this.token);

  String get query;
}