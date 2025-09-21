import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/repositories/auth/repository.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/repositories/profile/repository.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/data/repositories/auth/token_storage.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/auth/providers/di.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/profile/providers/di.dart';
import 'package:dartz/dartz.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/errors/failures.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/profile/entity.dart';

/// Mock implementation of AuthRepository for testing
class MockAuthRepository implements AuthRepository {
  final Map<String, String> _users = {}; // phone -> fullName
  final Map<String, String> _otps = {}; // phone -> otp
  final TokenStorage _tokenStorage;
  
  MockAuthRepository(this._tokenStorage);

  @override
  Future<Either<Failure, String>> register({
    required String fullName,
    required String phone,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Store user and generate OTP
    _users[phone] = fullName;
    final otp = '123456'; // Fixed OTP for testing
    _otps[phone] = otp;
    
    return Right(otp);
  }

  @override
  Future<Either<Failure, String>> verify({
    required String phone,
    required String otp,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (!_users.containsKey(phone)) {
      return Left(ServerFailure('User not found'));
    }
    
    if (_otps[phone] != otp) {
      return Left(ServerFailure('Invalid OTP'));
    }
    
    // Generate mock token and store candidate ID
    final token = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';
    final candidateId = 'candidate_${phone.hashCode}';
    
    await _tokenStorage.setToken(token);
    await _tokenStorage.setCandidateId(candidateId);
    
    return Right(token);
  }

  @override
  Future<Either<Failure, String>> loginStart({required String phone}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (!_users.containsKey(phone)) {
      return Left(ServerFailure('User not found'));
    }
    
    final otp = '123456'; // Fixed OTP for testing
    _otps[phone] = otp;
    
    return Right(otp);
  }

  @override
  Future<Either<Failure, String>> loginVerify({
    required String phone,
    required String otp,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (!_users.containsKey(phone)) {
      return Left(ServerFailure('User not found'));
    }
    
    if (_otps[phone] != otp) {
      return Left(ServerFailure('Invalid OTP'));
    }
    
    // Generate mock token
    final token = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';
    final candidateId = 'candidate_${phone.hashCode}';
    
    await _tokenStorage.setToken(token);
    await _tokenStorage.setCandidateId(candidateId);
    
    return Right(token);
  }

  @override
  Future<Either<Failure, String?>> getToken() async {
    final token = await _tokenStorage.getToken();
    return Right(token);
  }

  @override
  Future<Either<Failure, void>> logout() async {
    await _tokenStorage.clearToken();
    await _tokenStorage.clearCandidateId();
    return const Right(null);
  }
}

/// Mock implementation of ProfileRepository for testing
class MockProfileRepository implements ProfileRepository {
  final TokenStorage _tokenStorage;
  final Map<String, ProfileEntity> _profiles = {};
  
  MockProfileRepository(this._tokenStorage);

  @override
  Future<Either<Failure, void>> addProfile(ProfileEntity profile) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    final candidateId = await _tokenStorage.getCandidateId();
    if (candidateId == null) {
      return Left(ServerFailure('No candidate ID found'));
    }
    
    // Store profile data
    _profiles[candidateId] = profile;
    
    return const Right(null);
  }

  @override
  Future<Either<Failure, ProfileEntity?>> getProfile() async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    final candidateId = await _tokenStorage.getCandidateId();
    if (candidateId == null) {
      return Left(ServerFailure('No candidate ID found'));
    }
    
    return Right(_profiles[candidateId]);
  }
}

/// Provider overrides for testing
class MockProviders {
  static List<Override> createOverrides(TokenStorage tokenStorage) {
    return [
      // Override auth repository with mock
      authRepositoryProvider.overrideWithValue(
        MockAuthRepository(tokenStorage),
      ),
      
      // Override profile repository with mock  
      profileRepositoryProvider.overrideWithValue(
        MockProfileRepository(tokenStorage),
      ),
    ];
  }
}
