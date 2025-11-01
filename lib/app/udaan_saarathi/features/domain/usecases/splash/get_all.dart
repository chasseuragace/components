import 'package:dartz/dartz.dart';
import '../../entities/splash/entity.dart';
import '../../repositories/splash/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class GetAllSplashUseCase implements UseCase<List<SplashEntity>, NoParm> {
  final SplashRepository repository;

  GetAllSplashUseCase(this.repository);

  @override
  Future<Either<Failure, List<SplashEntity>>> call(NoParm params) async {
    return repository.getAllItems();
  }
}
