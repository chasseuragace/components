import '../../models/search/model.dart';
import 'package:openapi/openapi.dart';
import '../../../../core/config/api_config.dart';
import '../../../domain/entities/search/search_params.dart';
import '../../../domain/entities/search/paginated_search_result.dart';

abstract class SearchRemoteDataSource {
  Future<List<SearchModel>> getAllItems();
  Future<SearchModel?> getItemById(String id);
  Future<void> addItem(SearchModel model);
  Future<void> updateItem(SearchModel model);
  Future<void> deleteItem(String id);
  Future<PaginatedSearchResult> searchAgencies(SearchParams params);
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final AgenciesApi _api;

  SearchRemoteDataSourceImpl() : _api = ApiConfig.client().getAgenciesApi();

  @override
  Future<List<SearchModel>> getAllItems() async {
   throw UnimplementedError();
  }

  @override
  Future<SearchModel?> getItemById(String id) async {
   throw UnimplementedError();
  }

  @override
  Future<void> addItem(SearchModel model) async {
   throw UnimplementedError();
  }

  @override
  Future<void> updateItem(SearchModel model) async {
   throw UnimplementedError();
  }

  @override
  Future<void> deleteItem(String id) async {
   throw UnimplementedError();
  }

  @override
  Future<PaginatedSearchResult> searchAgencies(SearchParams params) async {
    try {
      final response = await _api.agencyControllerSearchAgencies(
        keyword: params.keyword,
        page: params.page,
        limit: params.limit,
        sortBy: params.sortBy,
        sortOrder: params.sortOrder,
      );

      if (response.statusCode == 200 && response.data != null) {
        final paginatedResponse = response.data!;
        final agencies = paginatedResponse.data
            .map((dto) => SearchModel.fromApiDto(dto))
            .toList();

        return PaginatedSearchResult(
          data: agencies,
          total: paginatedResponse.meta.total?.toInt() ?? 0,
          page: paginatedResponse.meta.page?.toInt() ?? 1,
          limit: paginatedResponse.meta.limit?.toInt() ?? 10,
          totalPages: paginatedResponse.meta.totalPages?.toInt() ?? 0,
        );
      } else {
        throw Exception('Failed to search agencies: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching agencies: $e');
    }
  }
}
