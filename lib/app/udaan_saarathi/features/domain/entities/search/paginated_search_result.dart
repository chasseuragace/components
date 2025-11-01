import 'entity.dart';

class PaginatedSearchResult {
  final List<SearchEntity> data;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  const PaginatedSearchResult({
    required this.data,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  PaginatedSearchResult copyWith({
    List<SearchEntity>? data,
    int? total,
    int? page,
    int? limit,
    int? totalPages,
  }) {
    return PaginatedSearchResult(
      data: data ?? this.data,
      total: total ?? this.total,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      totalPages: totalPages ?? this.totalPages,
    );
  }
}

