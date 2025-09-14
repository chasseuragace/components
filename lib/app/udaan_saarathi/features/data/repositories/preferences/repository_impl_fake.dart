import 'package:dartz/dartz.dart';
import 'package:openapi/openapi.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/config/api_config.dart';

import '../../../../core/errors/failures.dart';
import '../../../domain/entities/preferences/entity.dart';
import '../../../domain/repositories/preferences/repository.dart';

import '../../datasources/preferences/local_data_source.dart';
import '../../datasources/preferences/remote_data_source.dart';
import '../../models/preferences/model.dart';
import '../../repositories/auth/token_storage.dart';


// NOTE: All option lists have been moved to OptionsDataSource
// This repository now only contains user preference data, not option definitions

class PreferencesRepositoryFake implements PreferencesRepository {
  final PreferencesLocalDataSource localDataSource;
  final PreferencesRemoteDataSource remoteDataSource;
  // Provide API like AuthRepositoryImpl for future integration
  final CandidatesApi _api;
  final TokenStorage _storage;

  PreferencesRepositoryFake({
    required this.localDataSource,
    required this.remoteDataSource,
    required TokenStorage storage,
    CandidatesApi? api,
  })  : _storage = storage,
        _api = api ?? ApiConfig.client().getCandidatesApi();

  @override
  Future<Either<Failure, List<PreferencesEntity>>> getAllItems() async {
    try {
      // Attempt real API if candidateId available; fallback to fake data
      final candidateId = await _storage.getCandidateId();


          final res =
              await _api.candidateControllerListPreferences(id: candidateId!);
          final List<PreferenceDto> items = res.data ?? const [];

          final mapped = items
              .map((p) => PreferencesModel(
                    id: p.id.toString(),
                    jobTitleId: p.jobTitleId.toString(),
                    name: p.title,
                    rawJson: p.toJson(),
                  ))
              .where((m) => m.id.isNotEmpty && m.jobTitleId.isNotEmpty)
              .toList();
          return right(mapped);
        
      
      // Fake data fallback
       } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, PreferencesEntity?>> getItemById(String id) async {
    try {
 
throw UnimplementedError();
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> addItem(PreferencesEntity entity) async {
    try {
      // Simulate delay
      await Future.delayed(Duration(milliseconds: 300));

      // No actual data operation in fake implementation
      return right(unit);
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateItem(PreferencesEntity entity) async {
    try {
      // Step 1: Save to local storage first (faster feedback)
      await localDataSource.updateItem(entity as PreferencesModel);
      // print('Preferences saved to local storage: ${entity.id}');
      
      // // Step 2: Send to server
      // final candidateId = await _storage.getCandidateId();
      // if (candidateId != null) {
      //   try {
      //     final updateDto = UpdatePreferenceDto(
      //       // Map entity data to DTO format
      //       preferences: entity.rawJson,
      //     );
          
      //     await _api.candidateControllerUpdatePreferences(
      //       id: candidateId,
      //       updatePreferenceDto: updateDto,
      //     );
      //     print('Preferences synced to server: ${entity.id}');
      //   } catch (serverError) {
      //     print('Server sync failed (saved locally): $serverError');
      //     // Don't fail the operation if local save succeeded
      //   }
      // }
      
      return right(unit);
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteItem(String id) async {
    try {
      // Simulate delay
      await Future.delayed(Duration(milliseconds: 300));

      // No actual data operation in fake implementation
      return right(unit);
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>?>> getFilter() async {
    try {
      // Try to get from server first, fallback to local storage
      final candidateId = await _storage.getCandidateId();
      
      if (candidateId != null) {
        try {
          // Get filter data from server
          // final res = await _api.candidateControllerGetFilter(id: candidateId);
          // if (res.data != null) {
          //   return right(res.data!.toJson());
          // }
          throw UnimplementedError();
        } catch (serverError) {
          print('Server filter fetch failed, using local/default: $serverError');
        }
      }
   final  filterData =  await  localDataSource.getFilter();
      // // Fallback to default filter/template data
      // final filterData = {
      //   'countries': [
      //     {
      //       'label': 'Bulgaria',
      //       'value': '4b62a218-3849-4909-87bc-6434f07b75d5',
      //     },
      //     {
      //       'label': 'Cyprus',
      //       'value': '54fb3d0e-f55c-4bc3-97dd-18cb5b406bef',
      //     },
      //   ],
      //   'salaryRange': {
      //     'min': 800.0,
      //     'max': 3600.0,
      //   },
      // };
      
      return right(filterData!);
    } catch (error) {
      return left(ServerFailure());
    }
  }
}
