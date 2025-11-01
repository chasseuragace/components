import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../domain/entities/job_title/entity.dart';
import '../../../domain/repositories/job_title/repository.dart';
import '../../datasources/job_title/local_data_source.dart';
import '../../datasources/job_title/remote_data_source.dart';
import '../../models/job_title/model.dart';
class JobTitleRepositoryImpl implements JobTitleRepository {
  final JobTitleLocalDataSource localDataSource;
  final JobTitleRemoteDataSource remoteDataSource;

  JobTitleRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<JobTitleEntity>>> getAllItems() async {
    try {
      final remoteItems = await remoteDataSource.getAllItems();
      return right(remoteItems);
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, JobTitleEntity?>> getItemById(String id) async {
    try {
      final remoteItem = await remoteDataSource.getItemById(id);
      return right(remoteItem);
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> addItem(JobTitleEntity entity) async {
    try {
      await remoteDataSource.addItem((entity as JobTitle));
      return right(unit);
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateItem(JobTitleEntity entity) async {
    try {
      await remoteDataSource.updateItem((entity as JobTitle));
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
}
extension model on JobTitleEntity {
  JobTitle toModel() {
    throw UnimplementedError();
  }
}
