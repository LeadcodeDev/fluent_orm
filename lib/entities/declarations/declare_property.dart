abstract interface class DeclarePropertyContract {
  T get<T> (String key);
}

class DeclareProperty implements DeclarePropertyContract {
  final Map<String, dynamic> _bucket = {};
  final List<String> _properties;

  DeclareProperty(this._properties);

  List<String> get properties => _properties;

  @override
  T get<T> (String key) => switch (_properties.firstWhere((element) => element == key)) {
    String() when _bucket.containsKey(key) => _bucket[key],
    _ => throw Exception('property not found'),
  };
}