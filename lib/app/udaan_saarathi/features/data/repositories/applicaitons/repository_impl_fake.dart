import 'package:dartz/dartz.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/config/api_config.dart';
import '../../../../core/errors/failures.dart';
import '../../../domain/entities/applicaitons/entity.dart';
import '../../../domain/repositories/applicaitons/repository.dart';
import '../../datasources/applicaitons/local_data_source.dart';
import '../../datasources/applicaitons/remote_data_source.dart';
import '../../models/applicaitons/model.dart';
import 'package:openapi/openapi.dart';
// Fake data for Applicaitonss
      final remoteItems = [
        ApplicaitonsModel(

            rawJson: {},
          id: '1',
          name: 'Admin',
        ),
        ApplicaitonsModel(
        rawJson: {},
          id: '2',
          name: 'User',
        ),
        ApplicaitonsModel(
        rawJson: {},
          id: '3',
          name: 'Guest',
        ),
      ];
class ApplicaitonsRepositoryFake implements ApplicaitonsRepository {
  final ApplicaitonsLocalDataSource localDataSource;
  final ApplicaitonsRemoteDataSource remoteDataSource;
final api = ApiConfig.client().getApplicationsApi();
  ApplicaitonsRepositoryFake({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<ApplicaitonsEntity>>> getAllItems() async {
    try {
      // This method can be used to get all applications for a candidate
      // For now, return fake data, but in real implementation we'd call:
      // api.applicationControllerListForCandidate(id: candidateId)

      // Simulate delay
      await Future.delayed(Duration(milliseconds: 300));

      return right(remoteItems.map((model) => model).toList());
    } catch (error) {
      return left(ServerFailure(
        message: 'Failed to fetch applications',
        details: error.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, ApplicaitonsEntity?>> getItemById(String id) async {
    try {
      // Simulate delay
      await Future.delayed(Duration(milliseconds: 300));

      final remoteItem = remoteItems.firstWhere((item) => item.id == id,
          orElse: () => throw "Not found");
      return right(remoteItem);
    } catch (error) {
      return left(ServerFailure(
        message: 'Failed to fetch application',
        details: error.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, Unit>> addItem(ApplicaitonsEntity entity) async {
    try {
      // This is the job application method - apply for a job
      final applyJobDto = ApplyJobDto(
        candidateId: entity.id, // Assuming entity.id is candidate_id
        jobPostingId: entity.rawJson['job_posting_id'], // Job ID from rawJson
        note: entity.rawJson['note'] ?? 'Applied via mobile app',
        updatedBy: 'candidate-mobile-app',
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
}
