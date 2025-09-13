import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, String?>> getToken();
  Future<Either<Failure, Unit>> logout();

  Future<Either<Failure, String>> registerCandidate({required String fullName, required String phone});
  Future<Either<Failure, String>> verifyCandidate({required String phone, required String otp});

  Future<Either<Failure, String>> loginStart({required String phone});
  Future<Either<Failure, String>> loginVerify({required String phone, required String otp});
}
