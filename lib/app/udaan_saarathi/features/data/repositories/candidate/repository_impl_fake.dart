import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../domain/entities/candidate/entity.dart';
import '../../../domain/repositories/candidate/repository.dart';
import '../../datasources/candidate/local_data_source.dart';
import '../../datasources/candidate/remote_data_source.dart';
import '../../models/candidate/model.dart';
// Fake data for Candidates
      final remoteItems = [
        CandidateModel(

            rawJson: {},
          id: '1',
          name: 'Admin',
        ),
        CandidateModel(
        rawJson: {},
          id: '2',
          name: 'User',
        ),
        CandidateModel(
        rawJson: {},
          id: '3',
          name: 'Guest',
        ),
      ];
class CandidateRepositoryFake implements CandidateRepository {
  final CandidateLocalDataSource localDataSource;
  final CandidateRemoteDataSource remoteDataSource;

  CandidateRepositoryFake({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<CandidateEntity>>> getAllItems() async {
    try {
    

      // Simulate delay
      await Future.delayed(Duration(milliseconds: 300));

      return right(remoteItems.map((model) => model).toList());
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, CandidateEntity?>> getItemById(String id) async {
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
  Future<Either<Failure, Unit>> addItem(CandidateEntity entity) async {
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
  Future<Either<Failure, Unit>> updateItem(CandidateEntity entity) async {
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
