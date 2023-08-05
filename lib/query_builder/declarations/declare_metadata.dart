abstract interface class DeclareMetadataContract {
  String get modelName;
  String get tableName;
}

class DeclareMetadata implements DeclareMetadataContract {
  final Map<String, dynamic> bucket = {};

  @override
  String get modelName => bucket['modelName'];

  @override
  String get tableName => bucket['tableName'];
}