import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../repositories/auth/repository.dart';

class LoginVerifyParams {
  final String phone;
  final String otp;
  LoginVerifyParams({required this.phone, required this.otp});
}

class LoginVerifyUseCase implements UseCase<String, LoginVerifyParams> {
  final AuthRepository repository;
  LoginVerifyUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(LoginVerifyParams params) {
    return repository.loginVerify(phone: params.phone, otp: params.otp);
  }
}
