import 'package:dartz/dartz.dart';
import 'package:openapi/openapi.dart';
import '../../../../core/errors/failures.dart';
import '../../../domain/entities/job_title/entity.dart';
import '../../../domain/repositories/job_title/repository.dart';
import '../../datasources/job_title/local_data_source.dart';
import '../../datasources/job_title/remote_data_source.dart';
import '../../models/job_title/model.dart';
// Fake data for JobTitles
      final remoteItems = [
        JobTitleModel(

            rawJson: {},
          id: '1',
          title: 'Admin',
        ),
        JobTitleModel(
        rawJson: {},
          id: '2',
          title: 'User',
        ),
        JobTitleModel(
        rawJson: {},
          id: '3',
          title: 'Guest',
        ),
      ];
class JobTitleRepositoryFake implements JobTitleRepository {
  final JobTitleLocalDataSource localDataSource;
  final JobTitleRemoteDataSource remoteDataSource;
final aip = Openapi(basePathOverride: "http://localhost:3000").getJobTitlesApi();
  JobTitleRepositoryFake({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<JobTitleEntity>>> getAllItems() async {
    try {
      final response = await aip.jobTitleControllerListAll();

      // Simulate delay
      await Future.delayed(Duration(milliseconds: 300));

      final rawList = response.data?.data ?? [];
      final items = rawList
          .map((model) => JobTitleModel.fromJson(model.toJson()))
          .toList();
      return right(items);
    } catch (error) {
      print(error);
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, JobTitleEntity?>> getItemById(String id) async {
    try {
    
      // Simulate delay
      await Future.delayed(Duration(milliseconds: 300));

      final remoteItem = remoteItems.firstWhere((item) => item.id == id,
          orElse: () => throw "Not found");
      return right(remoteItem);
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> addItem(JobTitleEntity entity) async {
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
  Future<Either<Failure, Unit>> updateItem(JobTitleEntity entity) async {
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
