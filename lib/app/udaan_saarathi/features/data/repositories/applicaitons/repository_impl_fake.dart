import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../domain/entities/applicaitons/entity.dart';
import '../../../domain/repositories/applicaitons/repository.dart';
import '../../datasources/applicaitons/local_data_source.dart';
import '../../datasources/applicaitons/remote_data_source.dart';
import '../../models/applicaitons/model.dart';
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

  ApplicaitonsRepositoryFake({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<ApplicaitonsEntity>>> getAllItems() async {
    try {
    

      // Simulate delay
      await Future.delayed(Duration(milliseconds: 300));

      return right(remoteItems.map((model) => model).toList());
    } catch (error) {
      return left(ServerFailure());
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
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> addItem(ApplicaitonsEntity entity) async {
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
