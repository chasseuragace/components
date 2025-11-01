import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../domain/entities/Agency/entity.dart';
import '../../../domain/repositories/Agency/repository.dart';
import '../../datasources/Agency/local_data_source.dart';
import '../../datasources/Agency/remote_data_source.dart';
import '../../models/Agency/model.dart';
// Fake data for Agencys
      final remoteItems = [
        AgencyModel(

            rawJson: {},
          id: '1',
          name: 'Admin',
        ),
        AgencyModel(
        rawJson: {},
          id: '2',
          name: 'User',
        ),
        AgencyModel(
        rawJson: {},
          id: '3',
          name: 'Guest',
        ),
      ];
class AgencyRepositoryFake implements AgencyRepository {
  final AgencyLocalDataSource localDataSource;
  final AgencyRemoteDataSource remoteDataSource;

  AgencyRepositoryFake({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<AgencyEntity>>> getAllItems() async {
    try {
    

      // Simulate delay
      await Future.delayed(Duration(milliseconds: 300));

      return right(remoteItems.map((model) => model).toList());
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, AgencyEntity?>> getItemById(String id) async {
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
  Future<Either<Failure, Unit>> addItem(AgencyEntity entity) async {
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
  Future<Either<Failure, Unit>> updateItem(AgencyEntity entity) async {
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
