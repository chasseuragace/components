import 'package:dartz/dartz.dart';
import 'package:openapi/openapi.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/config/api_config.dart';
import '../../../../core/errors/failures.dart';
import '../../../domain/entities/candidate/entity.dart';
import '../../../domain/repositories/candidate/repository.dart';
import '../../../domain/validators/candidate_profile_validator.dart';
import '../../datasources/candidate/local_data_source.dart';
import '../../datasources/candidate/remote_data_source.dart';
import '../../models/candidate/model.dart';
import '../auth/token_storage.dart';

class CandidateRepositoryFake implements CandidateRepository {
  final CandidatesApi api = ApiConfig.client().getCandidatesApi();
  final ApplicationsApi applicationApi = ApiConfig.client().getApplicationsApi();
  final CandidateLocalDataSource localDataSource;
  final CandidateRemoteDataSource remoteDataSource;
  final TokenStorage _storage;

  CandidateRepositoryFake({
    required this.localDataSource,
    required this.remoteDataSource,
    required TokenStorage storage,
  }) : _storage = storage;

  @override
  Future<Either<Failure, List<CandidateEntity>>> getAllItems() async {
    try {
      // Currently no backend list; keep empty
      await Future.delayed(const Duration(milliseconds: 100));
      return right(<CandidateEntity>[]);
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, CandidateEntity?>> getItemById() async {
    try {
      // Prefer provided id; otherwise use stored candidate id
      final candidateId = (await _storage.getCandidateId()) ?? '';
      print('🔍 Attempting to fetch candidate profile for ID: $candidateId');
      
      if (candidateId.isEmpty) {
        print('❌ No candidate ID found in storage');
        return left(ServerFailure(
          message: 'No candidate ID available',
          details: 'Candidate ID is required to fetch profile but was not found in storage',
        ));
      }
      
      print('📡 Making API call to fetch candidate profile...');
      final res = await api.candidateControllerGetCandidateProfile(id: candidateId);
      print('📡 API response status: ${res.statusCode}');
      
      final dto = res.data;
      if (dto == null) {
        print('⚠️ API returned null data');
        return right(null);
      }
      
      print('✅ Successfully fetched candidate profile data');
      final model = CandidateModel.fromJson(dto.toJson());
      return right(model);
    } catch (error, stackTrace) {
      print('❌ Error fetching candidate profile: $error');
      print('📚 Stack trace: $stackTrace');
      return left(ServerFailure(
        message: 'Failed to fetch candidate profile',
        details: 'Error: ${error.toString()}',
      ));
    }
  }
  @override
  Future<Either<Failure, CandidateStatisticsModel?>> getCandidateAnalytycs() async {
    try {
      // Prefer provided id; otherwise use stored candidate id
      final candidateId = (await _storage.getCandidateId()) ?? '';
      print('🔍 Attempting to fetch candidate analytics for ID: $candidateId');
      
      if (candidateId.isEmpty) {
        print('❌ No candidate ID found in storage for analytics');
        return left(ServerFailure(
          message: 'No candidate ID available for analytics',
          details: 'Candidate ID is required to fetch analytics but was not found in storage',
        ));
      }
      
      print('📡 Making API call to fetch candidate analytics...');
      final res = await applicationApi.applicationControllerAnalytics(id: candidateId);
      print('📡 Analytics API response status: ${res.statusCode}');
      
      final dto = res.data;
      if (dto == null) {
        print('⚠️ Analytics API returned null data');
        return right(null);
      }
      
      print('✅ Successfully fetched candidate analytics data');
      final model = CandidateStatisticsModel.fromJson(dto.toJson());
      return right(model);
    } catch (error, stackTrace) {
      print('❌ Error fetching candidate analytics: $error');
      print('📚 Stack trace: $stackTrace');
      return left(ServerFailure(
        message: 'Failed to fetch candidate analytics',
        details: 'Error: ${error.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, Unit>> addItem(CandidateEntity entity) async {
    try {
      await Future.delayed(const Duration(milliseconds: 50));
      return right(unit);
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateItem(CandidateEntity entity) async {
    try {
      // Validate the candidate profile before updating
      print('🔍 Validating candidate profile before update...');
      final validationErrors = CandidateProfileValidator.validate(entity);
      
      if (validationErrors.isNotEmpty) {
        print('❌ Profile validation failed: ${validationErrors.join(', ')}');
        return left(ServerFailure(
          message: 'Profile validation failed',
          details: 'Validation errors: ${validationErrors.join(', ')}',
        ));
      }
      
      print('✅ Profile validation passed');
      
      // Use stored candidate id; UI need not supply it
      final candidateId = (await _storage.getCandidateId()) ?? '';
      print('🔍 Attempting to update candidate profile for ID: $candidateId');
      
      if (candidateId.isEmpty) {
        print('❌ No candidate ID found in storage for update');
        return left(ServerFailure(
          message: 'No candidate ID available for update',
          details: 'Candidate ID is required to update profile but was not found in storage',
        ));
      }
      
      final body = CandidateUpdateDto(
        fullName: entity.fullName,
        email: entity.email,
        gender: entity.gender == 'Male' ? CandidateUpdateDtoGenderEnum.male : entity.gender == 'Female'? CandidateUpdateDtoGenderEnum.female:null,
        address: entity.address != null
            ? AddressDto(
                name: entity.address!.name,
                coordinates: entity.address!.coordinates != null
                    ? CoordinatesDto(
                        lat: entity.address!.coordinates!.lat!,
                        lng: entity.address!.coordinates!.lng!,
                      )
                    : null,
                province: entity.address!.province,
                district: entity.address!.district,
                municipality: entity.address!.municipality,
                ward: entity.address!.ward,
              )
            : null,
        passportNumber: entity.passportNumber,
        isActive: entity.isActive,
      );
      
      print('📡 Making API call to update candidate profile...');
      final res = await api.candidateControllerUpdateCandidateProfile(
        id: candidateId,
        candidateUpdateDto: body,
      );
      print('📡 Update API response status: ${res.statusCode}');
      
      print('✅ Successfully updated candidate profile');
      return right(unit);
    } catch (error, stackTrace) {
      print('❌ Error updating candidate profile: $error');
      print('📚 Stack trace: $stackTrace');
      return left(ServerFailure(
        message: 'Failed to update candidate profile',
        details: 'Error: ${error.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteItem(String id) async {
    try {
      await Future.delayed(const Duration(milliseconds: 50));
      return right(unit);
    } catch (error) {
      return left(ServerFailure());
    }
  }
}
