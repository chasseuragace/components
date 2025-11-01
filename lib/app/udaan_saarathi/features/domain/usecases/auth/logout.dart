import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../repositories/auth/repository.dart';

class LogoutUseCase implements UseCase<Unit, NoParm> {
  final AuthRepository repository;
  LogoutUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(NoParm params) {
    return repository.logout();
  }
}
