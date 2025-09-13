
import 'package:dartz/dartz.dart';
import 'package:openapi/openapi.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/config/api_config.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/errors/failures.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/data/repositories/auth/token_storage.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/repositories/auth/repository.dart' as domain;

class AuthRepositoryImpl implements domain.AuthRepository {
  final TokenStorage _storage;
  final AuthApi _api;

  AuthRepositoryImpl({TokenStorage? storage, AuthApi? api})
      : _storage = storage ?? TokenStorage(),
        _api = api ?? ApiConfig.client().getAuthApi();

  @override
  Future<Either<Failure, String?>> getToken() async {
    try {
      final token = await _storage.getToken();
      return Right(token);
    } catch (_) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      await _storage.clearToken();
      return const Right(unit);
    } catch (_) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, String>> registerCandidate({required String fullName, required String phone}) async {
    try {
      final req = RegisterCandidateDto(fullName: fullName, phone: phone);
      final res = await _api.authControllerRegister(registerCandidateDto: req);
      return Right(res.data?.devOtp ?? '');
    } catch (_) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> verifyCandidate({required String phone, required String otp}) async {
    try {
      final req = VerifyOtpDto(phone: phone, otp: otp);
      final res = await _api.authControllerVerify(verifyOtpDto: req);
      final token = res.data?.token ?? '';
      if (token.isNotEmpty) {
        await _storage.setToken(token);
      }
      return Right(token);
    } catch (_) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> loginStart({required String phone}) async {
    try {
      final req = AuthControllerLoginStartRequest(phone: phone);
      final res = await _api.authControllerLoginStart(authControllerLoginStartRequest: req);
      return Right(res.data?.devOtp ?? '');
    } catch (_) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> loginVerify({required String phone, required String otp}) async {
    try {
      final req = VerifyOtpDto(phone: phone, otp: otp);
      final res = await _api.authControllerLoginVerify(verifyOtpDto: req);
      final token = res.data?.token ?? '';
      if (token.isNotEmpty) {
        await _storage.setToken(token);
      }
      return Right(token);
    } catch (_) {
      return Left(ServerFailure());
    }
  }
}
