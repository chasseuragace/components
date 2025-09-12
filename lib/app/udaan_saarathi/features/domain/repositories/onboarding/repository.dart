import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../entities/onboarding/entity.dart';

abstract class OnboardingRepository {
  Future<Either<Failure, List<OnboardingEntity>>> getAllItems();
  Future<Either<Failure, OnboardingEntity?>> getItemById(String id);
  Future<Either<Failure, Unit>> addItem(OnboardingEntity entity);
  Future<Either<Failure, Unit>> updateItem(OnboardingEntity entity);
  Future<Either<Failure, Unit>> deleteItem(String id);
}
