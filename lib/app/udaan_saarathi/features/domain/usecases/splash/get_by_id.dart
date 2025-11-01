import 'package:dartz/dartz.dart';
import '../../entities/splash/entity.dart';
import '../../repositories/splash/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class GetSplashByIdUseCase implements UseCase<SplashEntity?, String> {
  final SplashRepository repository;

  GetSplashByIdUseCase(this.repository);

  @override
  Future<Either<Failure, SplashEntity?>> call(String id) async {
    return repository.getItemById(id);
  }
}
