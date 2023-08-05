abstract interface class DeclarePropertyContract {
  T get<T> (String key);
}

class DeclareProperty implements DeclarePropertyContract {
  final Map<String, dynamic> bucket = {};
  final List<String> _properties;

  DeclareProperty(this._properties);

  List<String> get properties => _properties;

  @override
  T get<T> (String key) => switch (_properties.firstWhere((element) => element == key)) {
    String() when bucket.containsKey(key) => bucket[key],
    _ => throw Exception('property not found'),
  };
}