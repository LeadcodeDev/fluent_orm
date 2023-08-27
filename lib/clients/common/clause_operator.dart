enum ClauseOperator {
  equals('='),
  smallerThan('<'),
  greaterThan('>');

  final String uid;
  const ClauseOperator(this.uid);

  @override
  String toString() => uid;
}