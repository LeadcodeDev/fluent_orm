abstract interface class DeclarePropertyContract {
  T get<T> (String key);
}

class DeclareProperty implements DeclarePropertyContract {
  final Map<String, dynamic> _bucket;
  DeclareProperty(this._bucket);

  @override
  T get<T> (String key) => _bucket[key];
}