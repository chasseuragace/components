class SearchParams {
  final String? keyword;
  final int page;
  final int limit;
  final String? sortBy;
  final String? sortOrder;

  SearchParams({
    this.keyword,
    this.page = 1,
    this.limit = 10,
    this.sortBy,
    this.sortOrder,
  });
}

