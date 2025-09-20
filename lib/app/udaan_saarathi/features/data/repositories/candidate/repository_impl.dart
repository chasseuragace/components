import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../domain/entities/candidate/entity.dart';
import '../../../domain/repositories/candidate/repository.dart';
import '../../datasources/candidate/local_data_source.dart';
import '../../datasources/candidate/remote_data_source.dart';
import '../../models/candidate/model.dart';
class CandidateRepositoryImpl implements CandidateRepository {
  final CandidateLocalDataSource localDataSource;
  final CandidateRemoteDataSource remoteDataSource;

  CandidateRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<CandidateEntity>>> getAllItems() async {
    try {
      final remoteItems = await remoteDataSource.getAllItems();
      return right(remoteItems);
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, CandidateEntity?>> getItemById() async {
  throw
   UnimplementedError();
  }

  @override
  Future<Either<Failure, Unit>> addItem(CandidateEntity entity) async {
    try {
      await remoteDataSource.addItem((entity as CandidateModel));
      return right(unit);
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateItem(CandidateEntity entity) async {
    try {
      await remoteDataSource.updateItem((entity as CandidateModel));
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
  Future<Either<Failure, CandidateStatisticsEntity?>> getCandidateAnalytycs() {
    // TODO: implement getCandidateAnalytycs
    throw UnimplementedError();
  }
}
extension model on CandidateEntity {
  CandidateModel toModel() {
    throw UnimplementedError();
  }
}
