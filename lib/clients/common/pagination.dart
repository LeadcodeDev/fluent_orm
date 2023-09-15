abstract class Pagination<T> {
  final int currentPage;
  final int itemsPerPage;
  final int firstPage;
  final int lastPage;
  final List<T> data;

  Pagination({
    required this.currentPage,
    required this.itemsPerPage,
    required this.firstPage,
    required this.lastPage,
    required this.data,
  });

  Future<Pagination<T>> previous();
  Future<Pagination<T>> next();
}