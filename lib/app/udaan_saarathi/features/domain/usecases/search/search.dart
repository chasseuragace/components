import 'package:dartz/dartz.dart';
import '../../entities/search/search_params.dart';
import '../../entities/search/paginated_search_result.dart';
import '../../repositories/search/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class SearchAgenciesUseCase implements UseCase<PaginatedSearchResult, SearchParams> {
  final SearchRepository repository;

  SearchAgenciesUseCase(this.repository);

  @override
  Future<Either<Failure, PaginatedSearchResult>> call(SearchParams params) async {
    return repository.searchAgencies(params);
  }
}

