import 'package:dartz/dartz.dart';
import '../../entities/splash/entity.dart';
import '../../repositories/splash/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class UpdateSplashUseCase implements UseCase<Unit, SplashEntity> {
  final SplashRepository repository;

  UpdateSplashUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(SplashEntity entity) async {
    return repository.updateItem(entity);
  }
}
