import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../domain/entities/applicaitons/entity.dart';
import '../../../domain/repositories/applicaitons/repository.dart';
import '../../datasources/applicaitons/local_data_source.dart';
import '../../datasources/applicaitons/remote_data_source.dart';
import '../../models/applicaitons/model.dart';
class ApplicaitonsRepositoryImpl implements ApplicaitonsRepository {
  final ApplicaitonsLocalDataSource localDataSource;
  final ApplicaitonsRemoteDataSource remoteDataSource;

  ApplicaitonsRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<ApplicaitonsEntity>>> getAllItems() async {
    try {
      final remoteItems = await remoteDataSource.getAllItems();
      return right(remoteItems);
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, ApplicaitonsEntity?>> getItemById(String id) async {
    try {
      final remoteItem = await remoteDataSource.getItemById(id);
      return right(remoteItem);
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> addItem(ApplicaitonsEntity entity) async {
    try {
      await remoteDataSource.addItem((entity as ApplicaitonsModel));
      return right(unit);
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateItem(ApplicaitonsEntity entity) async {
    try {
      await remoteDataSource.updateItem((entity as ApplicaitonsModel));
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
  
  @override
  Future<Either<Failure, Unit>> applyJob(ApplicationEntity entity) {
    // TODO: implement applyJob
    throw UnimplementedError();
  }
}
extension model on ApplicaitonsEntity {
  ApplicaitonsModel toModel() {
    throw UnimplementedError();
  }
}
