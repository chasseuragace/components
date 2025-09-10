import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../domain/entities/jobs/entity.dart';
import '../../../domain/repositories/jobs/repository.dart';
import '../../datasources/jobs/local_data_source.dart';
import '../../datasources/jobs/remote_data_source.dart';
import '../../models/jobs/model.dart';
class JobsRepositoryImpl implements JobsRepository {
  final JobsLocalDataSource localDataSource;
  final JobsRemoteDataSource remoteDataSource;

  JobsRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<JobsEntity>>> getAllItems() async {
    try {
      final remoteItems = await remoteDataSource.getAllItems();
      return right(remoteItems);
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, JobsEntity?>> getItemById(String id) async {
    try {
      final remoteItem = await remoteDataSource.getItemById(id);
      return right(remoteItem);
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> addItem(JobsEntity entity) async {
    try {
      await remoteDataSource.addItem((entity as JobsModel));
      return right(unit);
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateItem(JobsEntity entity) async {
    try {
      await remoteDataSource.updateItem((entity as JobsModel));
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
extension model on JobsEntity {
  JobsModel toModel() {
    throw UnimplementedError();
  }
}
