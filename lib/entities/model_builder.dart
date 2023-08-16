class ModelBuilder {
  final Map<String, dynamic> bucket = {};

  @override
  noSuchMethod(Invocation invocation) {
    if (invocation.isSetter) {
      final name = invocation.memberName.toString()
        .replaceAll('Symbol("', '')
        .replaceAll('=")', '');

      bucket[name] = invocation.positionalArguments.first;
      return;
    }

    if (invocation.isGetter) {
      final name = invocation.memberName.toString()
        .replaceAll('Symbol("', '')
        .replaceAll('")', '');

      return bucket[name];
    }

    return super.noSuchMethod(invocation);
  }
}