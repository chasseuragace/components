import 'package:dartz/dartz.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/jobs/entity_mobile.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/jobs/grouped_jobs.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/jobs/jobs_search_results.dart' as search_entities;
import '../../entities/jobs/entity.dart';
import '../../../../core/errors/failures.dart';

import 'package:meta/meta.dart';

/// DTO for job search parameters
@immutable
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
    this.page = 1,
    this.limit = 2,
    this.sortBy,
    this.order,
  });

  JobSearchDTO copyWith({
    String? keyword,
    String? country,
    double? minSalary,
    double? maxSalary,
    String? currency,
    int? page,
    int? limit,
    String? sortBy,
    String? order,
  }) {
    return JobSearchDTO(
      keyword: keyword ?? this.keyword,
      country: country ?? this.country,
      minSalary: minSalary ?? this.minSalary,
      maxSalary: maxSalary ?? this.maxSalary,
      currency: currency ?? this.currency,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      sortBy: sortBy ?? this.sortBy,
      order: order ?? this.order,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JobSearchDTO &&
          runtimeType == other.runtimeType &&
          keyword == other.keyword &&
          country == other.country &&
          minSalary == other.minSalary &&
          maxSalary == other.maxSalary &&
          currency == other.currency &&
          page == other.page &&
          limit == other.limit &&
          sortBy == other.sortBy &&
          order == other.order;

  @override
  int get hashCode =>
      keyword.hashCode ^
      country.hashCode ^
      minSalary.hashCode ^
      maxSalary.hashCode ^
      currency.hashCode ^
      page.hashCode ^
      limit.hashCode ^
      sortBy.hashCode ^
      order.hashCode;
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
