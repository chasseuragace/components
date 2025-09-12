import 'package:dartz/dartz.dart';
import '../../entities/candidate/entity.dart';
import '../../../../core/errors/failures.dart';

abstract class CandidateRepository {
  Future<Either<Failure, List<CandidateEntity>>> getAllItems();
  Future<Either<Failure, CandidateEntity?>> getItemById(String id);
  Future<Either<Failure, Unit>> addItem(CandidateEntity entity);
  Future<Either<Failure, Unit>> updateItem(CandidateEntity entity);
  Future<Either<Failure, Unit>> deleteItem(String id);
}
