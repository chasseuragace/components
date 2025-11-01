import 'package:dartz/dartz.dart';
import '../../repositories/splash/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class DeleteSplashUseCase implements UseCase<Unit, String> {
  final SplashRepository repository;

  DeleteSplashUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String id) async {
    return repository.deleteItem(id);
  }
}
