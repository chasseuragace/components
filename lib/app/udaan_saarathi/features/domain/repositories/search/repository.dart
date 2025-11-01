import 'package:dartz/dartz.dart';
import '../../entities/search/entity.dart';
import '../../entities/search/search_params.dart';
import '../../entities/search/paginated_search_result.dart';
import '../../../../core/errors/failures.dart';

abstract class SearchRepository {
  Future<Either<Failure, List<SearchEntity>>> getAllItems();
  Future<Either<Failure, SearchEntity?>> getItemById(String id);
  Future<Either<Failure, Unit>> addItem(SearchEntity entity);
  Future<Either<Failure, Unit>> updateItem(SearchEntity entity);
  Future<Either<Failure, Unit>> deleteItem(String id);
  Future<Either<Failure, PaginatedSearchResult>> searchAgencies(SearchParams params);
}
