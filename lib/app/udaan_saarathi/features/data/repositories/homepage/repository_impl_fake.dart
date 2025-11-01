import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../domain/entities/homepage/entity.dart';
import '../../../domain/repositories/homepage/repository.dart';
import '../../datasources/homepage/local_data_source.dart';
import '../../datasources/homepage/remote_data_source.dart';
import '../../models/homepage/model.dart';
// Fake data for Homepages
      final remoteItems = [
        HomepageModel(

            rawJson: {},
          id: '1',
          name: 'Admin',
        ),
        HomepageModel(
        rawJson: {},
          id: '2',
          name: 'User',
        ),
        HomepageModel(
        rawJson: {},
          id: '3',
          name: 'Guest',
        ),
      ];
class HomepageRepositoryFake implements HomepageRepository {
  final HomepageLocalDataSource localDataSource;
  final HomepageRemoteDataSource remoteDataSource;

  HomepageRepositoryFake({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<HomepageEntity>>> getAllItems() async {
    try {
    

      // Simulate delay
      await Future.delayed(Duration(milliseconds: 300));

      return right(remoteItems.map((model) => model).toList());
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, HomepageEntity?>> getItemById(String id) async {
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
  Future<Either<Failure, Unit>> addItem(HomepageEntity entity) async {
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
  Future<Either<Failure, Unit>> updateItem(HomepageEntity entity) async {
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
