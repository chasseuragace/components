import 'package:dartz/dartz.dart';
import '../../entities/splash/entity.dart';
import '../../repositories/splash/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class AddSplashUseCase implements UseCase<Unit, SplashEntity> {
  final SplashRepository repository;

  AddSplashUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(SplashEntity entity) async {
    return repository.addItem(entity);
  }
}
