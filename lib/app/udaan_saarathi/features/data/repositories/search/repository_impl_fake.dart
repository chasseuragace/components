import 'package:dartz/dartz.dart';
import 'package:openapi/openapi.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/config/api_config.dart';
import '../../../../core/errors/failures.dart';
import '../../../domain/entities/search/entity.dart';
import '../../../domain/entities/search/search_params.dart';
import '../../../domain/entities/search/paginated_search_result.dart';
import '../../../domain/repositories/search/repository.dart';
import '../../datasources/search/local_data_source.dart';
import '../../datasources/search/remote_data_source.dart';
import '../../models/search/model.dart';

class SearchRepositoryFake implements SearchRepository {
  final SearchLocalDataSource localDataSource;
  final SearchRemoteDataSource remoteDataSource;
  final AgenciesApi _api;
  
  SearchRepositoryFake({
    required this.localDataSource,
    required this.remoteDataSource,
  }) : _api = ApiConfig.client().getAgenciesApi();

  @override
  Future<Either<Failure, List<SearchEntity>>> getAllItems() async {
    try {
      final result = await _api.agencyControllerSearchAgencies();

      // Simulate delay
      await Future.delayed(Duration(milliseconds: 300));

      if (result.statusCode == 200 && result.data != null) {
        final agencies = result.data!.data
            .map((dto) => SearchModel.fromApiDto(dto))
            .toList();
        return right(agencies);
      }
      return right([]);
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, SearchEntity?>> getItemById(String id) async {
    try {
      // Simulate delay
      await Future.delayed(Duration(milliseconds: 300));

      final result = await _api.agencyControllerSearchAgencies();
      if (result.statusCode == 200 && result.data != null) {
        final agency = result.data!.data.firstWhere(
          (item) => item.id == id,
          orElse: () => throw "Not found",
        );
        return right(SearchModel.fromApiDto(agency));
      }
      return right(null);
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> addItem(SearchEntity entity) async {
    try {
      // Simulate delay
      await Future.delayed(Duration(milliseconds: 300));

      // No actual data operation in fake implementation
      return right(unit);
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateItem(SearchEntity entity) async {
    try {
      // Simulate delay
      await Future.delayed(Duration(milliseconds: 300));

      // No actual data operation in fake implementation
      return right(unit);
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteItem(String id) async {
    try {
      // Simulate delay
      await Future.delayed(Duration(milliseconds: 300));

      // No actual data operation in fake implementation
      return right(unit);
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, PaginatedSearchResult>> searchAgencies(SearchParams params) async {
    try {
      final result = await _api.agencyControllerSearchAgencies(
        keyword: params.keyword,
        page: params.page,
        limit: params.limit,
        sortBy: params.sortBy,
        sortOrder: params.sortOrder,
      );

      if (result.statusCode == 200 && result.data != null) {
        final paginatedResponse = result.data!;
        final agencies = paginatedResponse.data
            .map((dto) => SearchModel.fromApiDto(dto))
            .toList();

        final paginatedResult = PaginatedSearchResult(
          data: agencies,
          total: paginatedResponse.meta.total?.toInt() ?? 0,
          page: paginatedResponse.meta.page?.toInt() ?? 1,
          limit: paginatedResponse.meta.limit?.toInt() ?? 10,
          totalPages: paginatedResponse.meta.totalPages?.toInt() ?? 0,
        );
        return right(paginatedResult);
      } else {
        return left(ServerFailure());
      }
    } catch (error) {
      return left(ServerFailure());
    }
  }
}
