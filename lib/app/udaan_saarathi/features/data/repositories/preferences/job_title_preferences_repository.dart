import 'package:dartz/dartz.dart';
import 'package:openapi/openapi.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/config/api_config.dart';
import '../../../../core/errors/failures.dart';
import '../auth/token_storage.dart';

abstract class JobTitlePreferencesRepository {
  Future<Either<Failure, Unit>> addJobTitlePreference(String jobTitleId, int priority);
  Future<Either<Failure, Unit>> removeJobTitlePreference(String title);
  Future<Either<Failure, Unit>> reorderJobTitlePreferences(List<String> orderedIds);
}

class JobTitlePreferencesRepositoryImpl implements JobTitlePreferencesRepository {
  final CandidatesApi _api;
  final TokenStorage _storage;

  JobTitlePreferencesRepositoryImpl({
    required TokenStorage storage,
    CandidatesApi? api,
  })  : _storage = storage,
        _api = api ?? ApiConfig.client().getCandidatesApi();

  @override
  Future<Either<Failure, Unit>> addJobTitlePreference(String jobTitleId, int priority) async {
    try {
      final candidateId = await _storage.getCandidateId();
      print('🔍 Attempting to add job title preference: $jobTitleId (priority: $priority)');
      
      if (candidateId == null) {
        print('❌ No candidate ID found in storage for preference');
        return left(ServerFailure(
          message: 'No candidate ID available for preference',
          details: 'Candidate ID is required to add preference but was not found in storage',
        ));
      }

      print('📡 Making API call to add job title preference...');
      // Create AddPreferenceDto with jobTitleId and priority
      final addPreferenceDto = AddPreferenceDto(
        title: jobTitleId,
      );

      final res = await _api.candidateControllerAddPreference(
        id: candidateId,
        addPreferenceDto: addPreferenceDto,
      );
      
      print('📡 Add preference API response status: ${res.statusCode}');
      print('✅ Successfully added job title preference');
      return right(unit);
    } catch (error, stackTrace) {
      print('❌ Error adding job title preference: $error');
      print('📚 Stack trace: $stackTrace');
      return left(ServerFailure(
        message: 'Failed to add job title preference',
        details: 'Error: ${error.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, Unit>> removeJobTitlePreference(String title) async {
    try {
      final candidateId = await _storage.getCandidateId();
      print('🔍 Attempting to remove job title preference: $title');
      
      if (candidateId == null) {
        print('❌ No candidate ID found in storage for preference removal');
        return left(ServerFailure(
          message: 'No candidate ID available for preference removal',
          details: 'Candidate ID is required to remove preference but was not found in storage',
        ));
      }

      print('📡 Making API call to remove job title preference...');
      final removePreferenceDto = RemovePreferenceDto(title: title);

      final res = await _api.candidateControllerRemovePreference(
        id: candidateId,
        removePreferenceDto: removePreferenceDto,
      );
      
      print('📡 Remove preference API response status: ${res.statusCode}');
      print('✅ Successfully removed job title preference');
      return right(unit);
    } catch (error, stackTrace) {
      print('❌ Error removing job title preference: $error');
      print('📚 Stack trace: $stackTrace');
      return left(ServerFailure(
        message: 'Failed to remove job title preference',
        details: 'Error: ${error.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, Unit>> reorderJobTitlePreferences(List<String> orderedIds) async {
    try {
      final candidateId = await _storage.getCandidateId();
      print('🔍 Attempting to reorder job title preferences: ${orderedIds.join(', ')}');
      
      if (candidateId == null) {
        print('❌ No candidate ID found in storage for preference reordering');
        return left(ServerFailure(
          message: 'No candidate ID available for preference reordering',
          details: 'Candidate ID is required to reorder preferences but was not found in storage',
        ));
      }

      print('📡 Making API call to reorder job title preferences...');
      final reorderPreferencesDto = ReorderPreferencesDto(orderedIds: orderedIds);

      final res = await _api.candidateControllerReorderPreferences(
        id: candidateId,
        reorderPreferencesDto: reorderPreferencesDto,
      );
      
      print('📡 Reorder preferences API response status: ${res.statusCode}');
      print('✅ Successfully reordered job title preferences');
      return right(unit);
    } catch (error, stackTrace) {
      print('❌ Error reordering job title preferences: $error');
      print('📚 Stack trace: $stackTrace');
      return left(ServerFailure(
        message: 'Failed to reorder job title preferences',
        details: 'Error: ${error.toString()}',
      ));
    }
  }
}