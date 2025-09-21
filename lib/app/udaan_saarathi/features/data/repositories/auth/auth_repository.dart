
import 'package:dartz/dartz.dart';
import 'package:openapi/openapi.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/config/api_config.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/errors/failures.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/data/repositories/auth/token_storage.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/repositories/auth/repository.dart' as domain;

class AuthRepositoryImpl implements domain.AuthRepository {
  final TokenStorage _storage;
  final AuthApi _api;

  AuthRepositoryImpl({required TokenStorage storage, AuthApi? api})
      : _storage = storage,
        _api = api ?? ApiConfig.client().getAuthApi();

  @override
  Future<Either<Failure, String?>> getToken() async {
    try {
      final token = await _storage.getToken();
      return Right(token);
    } catch (e) {
      return Left(CacheFailure(
        message: 'Failed to get token from storage',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      await _storage.clearToken();
      await _storage.clearCandidateId();
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure(
        message: 'Failed to clear tokens during logout',
        details: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, String>> registerCandidate({required String fullName, required String phone}) async {
    try {
      final req = RegisterCandidateDto(fullName: fullName, phone: "+977$phone");
      final res = await _api.authControllerRegister(registerCandidateDto: req);
      return Right(res.data?.devOtp ?? '');
    } catch (e) {
      return Left(ServerFailure(
        message: 'Failed to register candidate',
        details: 'Phone: $phone, Error: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, String>> verifyCandidate({required String phone, required String otp}) async {
    try {
      final req = VerifyOtpDto(phone: "+977$phone", otp: otp);
      final res = await _api.authControllerVerify(verifyOtpDto: req);
      final token = res.data?.token ?? '';
      if (token.isNotEmpty) {
        await _storage.setToken(token);
        // Set candidate ID - try candidateId first, then extract from candidate object
        String? candidateId = res.data?.candidateId;
        
        // Fallback: extract from nested candidate object if candidateId is null
        if (candidateId == null || candidateId.isEmpty) {
          final candidateData = res.data?.candidate;
          if (candidateData != null) {
            try {
              final candidateMap = candidateData as Map<String, dynamic>?;
              candidateId = candidateMap?['id'] as String?;
              print('🔄 Extracted candidate ID from nested object: $candidateId');
            } catch (e) {
              print('⚠️ Could not extract candidate ID from nested object: $e');
            }
          }
        }
        
        if (candidateId != null && candidateId.isNotEmpty) {
          await _storage.setCandidateId(candidateId);
          print('✅ Candidate ID stored: $candidateId');
        } else {
          print('❌ No candidate ID found anywhere in API response');
        }
      }
      return Right(token);
    } catch (e) {
      return Left(ServerFailure(
        message: 'Failed to verify candidate OTP',
        details: 'Phone: $phone, OTP: $otp, Error: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, String>> loginStart({required String phone}) async {
    try {
      final req = AuthControllerLoginStartRequest(phone: "+977$phone");
      final res = await _api.authControllerLoginStart(authControllerLoginStartRequest: req);
      return Right(res.data?.devOtp ?? '');
    } catch (e) {
      return Left(ServerFailure(
        message: 'Failed to start login process',
        details: 'Phone: $phone, Error: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, String>> loginVerify({required String phone, required String otp}) async {
    try {
      final req = VerifyOtpDto(phone: "+977$phone", otp: otp);
      final res = await _api.authControllerLoginVerify(verifyOtpDto: req);
      final token = res.data?.token ?? '';
      if (token.isNotEmpty) {
        await _storage.setToken(token);
        // Set candidate ID - try candidateId first, then extract from candidate object
        String? candidateId = res.data?.candidateId;
        
        // Fallback: extract from nested candidate object if candidateId is null
        if (candidateId == null || candidateId.isEmpty) {
          final candidateData = res.data?.candidate;
          if (candidateData != null) {
            try {
              final candidateMap = candidateData as Map<String, dynamic>?;
              candidateId = candidateMap?['id'] as String?;
              print('🔄 Extracted candidate ID from nested object: $candidateId');
            } catch (e) {
              print('⚠️ Could not extract candidate ID from nested object: $e');
            }
          }
        }
        
        if (candidateId != null && candidateId.isNotEmpty) {
          await _storage.setCandidateId(candidateId);
          print('✅ Candidate ID stored: $candidateId');
        } else {
          print('❌ No candidate ID found anywhere in API response');
        }
      }
      return Right(token);
    } catch (e) {
      return Left(ServerFailure(
        message: 'Failed to verify login OTP',
        details: 'Phone: $phone, OTP: $otp, Error: ${e.toString()}',
      ));
    }
  }
}
