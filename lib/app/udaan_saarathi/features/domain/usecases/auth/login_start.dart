import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../repositories/auth/repository.dart';

class LoginStartParams {
  final String phone;
  LoginStartParams({required this.phone});
}

class LoginStartUseCase implements UseCase<String, LoginStartParams> {
  final AuthRepository repository;
  LoginStartUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(LoginStartParams params) {
    return repository.loginStart(phone: params.phone);
  }
}
