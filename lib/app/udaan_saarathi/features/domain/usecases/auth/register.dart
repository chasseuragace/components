import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../repositories/auth/repository.dart';

class RegisterParams {
  final String fullName;
  final String phone;
  RegisterParams({required this.fullName, required this.phone});
}

class RegisterCandidateUseCase implements UseCase<String, RegisterParams> {
  final AuthRepository repository;
  RegisterCandidateUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(RegisterParams params) {
    return repository.registerCandidate(fullName: params.fullName, phone: params.phone);
  }
}
