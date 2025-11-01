import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../entities/jobs/jobs_search_results.dart' as search_entities;
import '../../repositories/jobs/repository.dart';

class GetAllJobsUseCase implements UseCase<search_entities.PaginatedJobsSearchResults, NoParm> {
  final JobsRepository repository;

  GetAllJobsUseCase(this.repository);

  @override
  Future<Either<Failure, search_entities.PaginatedJobsSearchResults>> call(NoParm params) async {
    return repository.getAllItems();
  }
}
