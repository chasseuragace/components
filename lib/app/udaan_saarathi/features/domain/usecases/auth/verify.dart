import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../repositories/auth/repository.dart';

class VerifyParams {
  final String phone;
  final String otp;
  VerifyParams({required this.phone, required this.otp});
}

class VerifyCandidateUseCase implements UseCase<String, VerifyParams> {
  final AuthRepository repository;
  VerifyCandidateUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(VerifyParams params) {
    return repository.verifyCandidate(phone: params.phone, otp: params.otp);
  }
}
