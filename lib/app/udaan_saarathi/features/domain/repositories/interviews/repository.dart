import 'package:dartz/dartz.dart';
import '../../entities/interviews/entity.dart';
import '../../../../core/errors/failures.dart';

abstract class InterviewsRepository {
  Future<Either<Failure, InterviewsPaginationEntity>> getAllItems({
    required int page,
    required int limit,
  });
  Future<Either<Failure, InterviewsEntity?>> getItemById(String id);
  Future<Either<Failure, Unit>> addItem(InterviewsEntity entity);
  Future<Either<Failure, Unit>> updateItem(InterviewsEntity entity);
  Future<Either<Failure, Unit>> deleteItem(String id);
}
