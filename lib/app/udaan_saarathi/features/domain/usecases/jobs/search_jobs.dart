import 'package:dartz/dartz.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/jobs/jobs_search_results.dart' as search_entities;
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../repositories/jobs/repository.dart';

class SearchJobsUseCase implements UseCase<search_entities.PaginatedJobsSearchResults, JobSearchDTO> {
  final JobsRepository repository;

  SearchJobsUseCase(this.repository);

  @override
  Future<Either<Failure, search_entities.PaginatedJobsSearchResults>> call(JobSearchDTO params) async {
    return await repository.searchJobs(params);
  }
}
