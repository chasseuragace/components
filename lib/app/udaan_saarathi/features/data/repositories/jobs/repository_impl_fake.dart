import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../domain/entities/jobs/entity.dart';
import '../../../domain/repositories/jobs/repository.dart';
import '../../datasources/jobs/local_data_source.dart';
import '../../datasources/jobs/remote_data_source.dart';
import '../../models/jobs/model.dart';

// final String isActive = isActive_example; // String |
// final String q = q_example; // String |
// final String limit = limit_example; // String |
// final String offset = offset_example; // String |

// try {
//     api.jobTitleControllerListAll(isActive, q, limit, offset);
// } catch on DioException (e) {
//     print('Exception when calling DefaultApi->jobTitleControllerListAll: $e\n');
// }
// Fake data for Jobss
final remoteItems = [
  JobsModel(
    rawJson: {},
    id: '1',
    name: 'Admin',
  ),
  JobsModel(
    rawJson: {},
    id: '2',
    name: 'User',
  ),
  JobsModel(
    rawJson: {},
    id: '3',
    name: 'Guest',
  ),
];

class JobsRepositoryFake implements JobsRepository {

  final JobsLocalDataSource localDataSource;
  final JobsRemoteDataSource remoteDataSource;

  JobsRepositoryFake({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<JobsEntity>>> getAllItems() async {
    try {
     // Simulate delay
      await Future.delayed(Duration(milliseconds: 300));
      return right(remoteItems.map((model) => model).toList());
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, JobsEntity?>> getItemById(String id) async {
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
  Future<Either<Failure, Unit>> addItem(JobsEntity entity) async {
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
  Future<Either<Failure, Unit>> updateItem(JobsEntity entity) async {
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
