import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../repositories/auth/repository.dart';

class GetTokenUseCase implements UseCase<String?, NoParm> {
  final AuthRepository repository;
  GetTokenUseCase(this.repository);

  @override
  Future<Either<Failure, String?>> call(NoParm params) {
    return repository.getToken();
  }
}
