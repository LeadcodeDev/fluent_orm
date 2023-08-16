abstract interface class DeclarePropertyContract {
  T get<T> (String key);
}

class DeclareProperty implements DeclarePropertyContract {
  final Map<String, dynamic> bucket = {};

  @override
  T get<T> (String key) => bucket[key];
}