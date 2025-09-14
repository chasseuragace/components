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
      if (candidateId == null) {
        return left(ServerFailure());
      }

      // Create AddPreferenceDto with jobTitleId and priority
      final addPreferenceDto = AddPreferenceDto(
   title  :  jobTitleId,

      );

      await _api.candidateControllerAddPreference(
        id: candidateId,
        addPreferenceDto: addPreferenceDto,
      );

      return right(unit);
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> removeJobTitlePreference(String title) async {
    try {
      final candidateId = await _storage.getCandidateId();
      if (candidateId == null) {
        return left(ServerFailure());
      }

      final removePreferenceDto = RemovePreferenceDto(title: title);

      await _api.candidateControllerRemovePreference(
        id: candidateId,
        removePreferenceDto: removePreferenceDto,
      );

      return right(unit);
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> reorderJobTitlePreferences(List<String> orderedIds) async {
    try {
      final candidateId = await _storage.getCandidateId();
      if (candidateId == null) {
        return left(ServerFailure());
      }

      final reorderPreferencesDto = ReorderPreferencesDto(orderedIds: orderedIds);

      await _api.candidateControllerReorderPreferences(
        id: candidateId,
        reorderPreferencesDto: reorderPreferencesDto,
      );

      return right(unit);
    } catch (error) {
      return left(ServerFailure());
    }
  }
}