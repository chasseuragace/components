import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../domain/entities/search/entity.dart';
import '../../../domain/entities/search/search_params.dart';
import '../../../domain/entities/search/paginated_search_result.dart';
import '../../../domain/repositories/search/repository.dart';
import '../../datasources/search/local_data_source.dart';
import '../../datasources/search/remote_data_source.dart';
import '../../models/search/model.dart';
class SearchRepositoryImpl implements SearchRepository {
  final SearchLocalDataSource localDataSource;
  final SearchRemoteDataSource remoteDataSource;

  SearchRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<SearchEntity>>> getAllItems() async {
    try {
      final remoteItems = await remoteDataSource.getAllItems();
      return right(remoteItems);
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, SearchEntity?>> getItemById(String id) async {
    try {
      final remoteItem = await remoteDataSource.getItemById(id);
      return right(remoteItem);
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> addItem(SearchEntity entity) async {
    try {
      await remoteDataSource.addItem((entity as SearchModel));
      return right(unit);
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateItem(SearchEntity entity) async {
    try {
      await remoteDataSource.updateItem((entity as SearchModel));
      return right(unit);
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteItem(String id) async {
    try {
      await remoteDataSource.deleteItem(id);
      return right(unit);
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, PaginatedSearchResult>> searchAgencies(SearchParams params) async {
    try {
      final result = await remoteDataSource.searchAgencies(params);
      return right(result);
    } catch (error) {
      return left(ServerFailure());
    }
  }
}
extension model on SearchEntity {
  SearchModel toModel() {
    throw UnimplementedError();
  }
}
