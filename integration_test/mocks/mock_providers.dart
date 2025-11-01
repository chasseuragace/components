import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/repositories/auth/repository.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/repositories/profile/repository.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/data/repositories/auth/token_storage.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/auth/providers/di.dart';
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
  Future<Either<Failure, String>> registerCandidate({
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
  Future<Either<Failure, String>> verifyCandidate({
    required String phone,
    required String otp,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (!_users.containsKey(phone)) {
      return Left(ServerFailure());
    }
    
    if (_otps[phone] != otp) {
      return Left(ServerFailure());
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
      return Left(ServerFailure());
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
      return Left(ServerFailure());
    }
    
    if (_otps[phone] != otp) {
      return Left(ServerFailure());
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
  Future<Either<Failure, Unit>> logout() async {
    await _tokenStorage.clearToken();
    await _tokenStorage.clearCandidateId();
    return const Right(unit);
  }
}

/// Mock implementation of ProfileRepository for testing
class MockProfileRepository implements ProfileRepository {
  final TokenStorage _tokenStorage;
  final Map<String, ProfileEntity> _profiles = {};
  
  MockProfileRepository(this._tokenStorage);

  @override
  Future<Either<Failure, List<ProfileEntity>>> getAllItems() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return Right(_profiles.values.toList());
  }

  @override
  Future<Either<Failure, ProfileEntity?>> getItemById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return Right(_profiles[id]);
  }

  @override
  Future<Either<Failure, Unit>> addItem(ProfileEntity entity) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    final candidateId = await _tokenStorage.getCandidateId();
    if (candidateId == null) {
      return Left(ServerFailure());
    }
    
    // Store profile data
    _profiles[candidateId] = entity;
    
    return const Right(unit);
  }

  @override
  Future<Either<Failure, Unit>> updateItem(ProfileEntity entity) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    final candidateId = await _tokenStorage.getCandidateId();
    if (candidateId == null) {
      return Left(ServerFailure());
    }
    
    _profiles[candidateId] = entity;
    return const Right(unit);
  }

  @override
  Future<Either<Failure, Unit>> deleteItem(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _profiles.remove(id);
    return const Right(unit);
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
      
      // Note: Profile repository will use the existing fake implementation
      // which should work fine for integration testing
    ];
  }
}
