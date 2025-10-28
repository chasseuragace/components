import 'package:dartz/dartz.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/jobs/entity_mobile.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/jobs/grouped_jobs.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/jobs/jobs_search_results.dart' as search_entities;
import '../../entities/jobs/entity.dart';
import '../../../../core/errors/failures.dart';

/// DTO for job search parameters
class JobSearchDTO {
  final String? keyword;
  final String? country;
  final double? minSalary;
  final double? maxSalary;
  final String? currency;
  final int? page;
  final int? limit;
  final String? sortBy;
  final String? order;

  const JobSearchDTO({
    this.keyword,
    this.country,
    this.minSalary,
    this.maxSalary,
    this.currency,
    this.page,
    this.limit,
    this.sortBy,
    this.order,
  });
}

abstract class JobsRepository {
  Future<Either<Failure, search_entities.PaginatedJobsSearchResults>> getAllItems();
  Future<Either<Failure, MobileJobEntity>> getItemById(String id);
  Future<Either<Failure, Unit>> addItem(JobsEntity entity);
  Future<Either<Failure, Unit>> updateItem(JobsEntity entity);
  Future<Either<Failure, Unit>> deleteItem(String id);
  Future<Either<Failure, GroupedJobsEntity>> getGroupedJobs();
  Future<Either<Failure, search_entities.PaginatedJobsSearchResults>> searchJobs(JobSearchDTO dto);
}
