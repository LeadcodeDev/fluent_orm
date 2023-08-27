abstract interface class DeclareMetadataContract {
  String get modelName;
  String get tableName;
}

class DeclareMetadata implements DeclareMetadataContract {
  final Map<String, dynamic> _bucket;
  DeclareMetadata(this._bucket);

  @override
  String get modelName => _bucket['modelName'];

  @override
  String get tableName => _bucket['tableName'];
}