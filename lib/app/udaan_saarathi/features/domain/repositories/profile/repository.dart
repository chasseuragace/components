import 'package:dartz/dartz.dart';
import '../../entities/profile/entity.dart';
import '../../../../core/errors/failures.dart';

abstract class ProfileRepository {
  Future<Either<Failure, List<ProfileEntity>>> getAllItems();
  Future<Either<Failure, ProfileEntity?>> getItemById(String id);
  Future<Either<Failure, Unit>> addItem(ProfileEntity entity);
  Future<Either<Failure, Unit>> updateItem(ProfileEntity entity);
  Future<Either<Failure, Unit>> deleteItem(String id);
}
