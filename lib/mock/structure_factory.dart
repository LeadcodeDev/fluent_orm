class StructureFactory<T> {
  final Map<String, dynamic> payload;
  final T model;

  StructureFactory(this.payload, this.model);
}