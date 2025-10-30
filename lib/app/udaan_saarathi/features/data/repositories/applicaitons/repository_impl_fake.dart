import 'package:dartz/dartz.dart';
import 'package:openapi/openapi.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/config/api_config.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/data/models/applicaitons/application_details_model.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/data/repositories/auth/token_storage.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/applicaitons/application_pagination_wrapper.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/applicaitons/apply_job_d_t_o_entity.dart';

import '../../../../core/errors/failures.dart';
import '../../../domain/entities/applicaitons/entity.dart';
import '../../../domain/repositories/applicaitons/repository.dart';
import '../../datasources/applicaitons/local_data_source.dart';
import '../../datasources/applicaitons/remote_data_source.dart';
import '../../models/applicaitons/model.dart';

class ApplicaitonsRepositoryFake implements ApplicaitonsRepository {
  final ApplicaitonsLocalDataSource localDataSource;
  final ApplicaitonsRemoteDataSource remoteDataSource;
  final TokenStorage _storage;

  final api = ApiConfig.client().getApplicationsApi();
  ApplicaitonsRepositoryFake({
    required this.localDataSource,
    required this.remoteDataSource,
    required TokenStorage storage,
  }) : _storage = storage;

  @override
  Future<Either<Failure, ApplicationPaginationWrapper>> getAllItems() async {
    try {
      final candidateId = await _storage.getCandidateId();
      final result =
          await api.applicationControllerListForCandidate(id: candidateId!);
      final items = result.data?.items
          .map((e) => ApplicaitonsModel.fromJson(e.toJson()))
          .toList();
      final wrapper = ApplicationPaginationWrapper(
          items: items ?? [],
          page: result.data?.page.toInt(),
          total: result.data?.total.toInt(),
          limit: result.data?.limit.toInt());
      return right(wrapper);
    } catch (error, s) {
      print(error);
      print(s);
      return left(ServerFailure(
        message: 'Failed to fetch applications',
        details: error.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, ApplicationDetailsModel>> getItemById(
      String id) async {
    try {
      // Simulate delay
      await Future.delayed(Duration(milliseconds: 300));

      final response =
          await api.applicationControllerGetApplicationById(id: id);
      final remoteItem =
          ApplicationDetailsModel.fromJson(response.data!.toJson());
      return right(remoteItem);
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      return left(ServerFailure(
        message: 'Failed to fetch application',
        details: error.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateItem(ApplicaitonsEntity entity) async {
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
  Future<Either<Failure, Unit>> applyJob(ApplyJobDTOEntity entity) async {
    try {
      // This is the job application method - apply for a job
      final candidateId = await _storage.getCandidateId();
      if (candidateId == null) {
        return left(ServerFailure());
      }

      final applyJobDto = ApplyJobDto(
        positionId: entity.positionId,
        candidateId: candidateId, // Assuming entity.id is candidate_id
        jobPostingId: entity.jobPostingId, // Job ID from rawJson
        note: entity.note,
      );

      final response = await api.applicationControllerApply(
        applyJobDto: applyJobDto, // Send proper DTO
      );

      print('✅ Job application submitted successfully');
      print('📋 Response: ${response.statusCode}');
      print('📋 Application ID: ${response.data?.id}');

      return right(unit);
    } catch (error) {
      print('❌ Job application failed: $error');
      return left(ServerFailure(
        message: 'Failed to apply for job',
        details: error.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, Unit>> withdrawJob(String id) async {
    try {
      // Simulate delay
      await Future.delayed(Duration(milliseconds: 300));

      final response = await api.applicationControllerWithdraw(id: id);
      print(response.statusCode);

      return right(unit);
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      return left(ServerFailure(
        message: 'Failed to withdraw application',
        details: error.toString(),
      ));
    }
  }
}
