import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../domain/entities/Agency/entity.dart';
import '../../../domain/repositories/Agency/repository.dart';
import '../../datasources/Agency/local_data_source.dart';
import '../../datasources/Agency/remote_data_source.dart';
import '../../models/Agency/model.dart';
class AgencyRepositoryImpl implements AgencyRepository {
  final AgencyLocalDataSource localDataSource;
  final AgencyRemoteDataSource remoteDataSource;

  AgencyRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<AgencyEntity>>> getAllItems() async {
    try {
      final remoteItems = await remoteDataSource.getAllItems();
      return right(remoteItems);
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, AgencyEntity?>> getItemById(String id) async {
    try {
      final remoteItem = await remoteDataSource.getItemById(id);
      return right(remoteItem);
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> addItem(AgencyEntity entity) async {
    try {
      await remoteDataSource.addItem((entity as AgencyModel));
      return right(unit);
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateItem(AgencyEntity entity) async {
    try {
      await remoteDataSource.updateItem((entity as AgencyModel));
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
extension model on AgencyEntity {
  AgencyModel toModel() {
    throw UnimplementedError();
  }
}
