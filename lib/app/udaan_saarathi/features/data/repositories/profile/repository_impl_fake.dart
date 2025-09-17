import 'package:dartz/dartz.dart';
import 'package:openapi/openapi.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/config/api_config.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/data/repositories/auth/token_storage.dart';

import '../../../../core/errors/failures.dart';
import '../../../domain/entities/profile/entity.dart';
import '../../../domain/repositories/profile/repository.dart';
import '../../datasources/profile/local_data_source.dart';
import '../../datasources/profile/remote_data_source.dart';

// Fake data for Profiles
// final remoteItems = [
//   ProfileModel(
//     rawJson: {},
//     id: '1',
//     name: 'Admin',
//   ),
//   ProfileModel(
//     rawJson: {},
//     id: '2',
//     name: 'User',
//   ),
//   ProfileModel(
//     rawJson: {},
//     id: '3',
//     name: 'Guest',
//   ),
// ];

class ProfileRepositoryFake implements ProfileRepository {
  final ProfileLocalDataSource localDataSource;
  final ProfileRemoteDataSource remoteDataSource;
  final CandidatesApi _api;
  final TokenStorage _storage;
  ProfileRepositoryFake({
    required this.localDataSource,
    required this.remoteDataSource,
    required TokenStorage storage,
    CandidatesApi? api,
  })  : _storage = storage,
        _api = api ?? ApiConfig.client().getCandidatesApi();

  @override
  Future<Either<Failure, List<ProfileEntity>>> getAllItems() async {
    // try {
    //   // Simulate delay
    //   await Future.delayed(Duration(milliseconds: 300));

    //   return right(remoteItems.map((model) => model).toList());
    // } catch (error) {
    //   return left(ServerFailure());
    // }
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, ProfileEntity?>> getItemById(String id) async {
    // try {
    //   // Simulate delay
    //   await Future.delayed(Duration(milliseconds: 300));

    //   final remoteItem = remoteItems.firstWhere((item) => item.id == id,
    //       orElse: () => throw "Not found");
    //   return right(remoteItem);
    // } catch (error) {
    //   return left(ServerFailure());
    // }
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Unit>> addItem(ProfileEntity entity) async {
    try {
      // Simulate delay
      final candidateId = await _storage.getCandidateId();
      if (candidateId == null) {
        return left(ServerFailure());
      }
      final jobProfileDto = AddJobProfileDto(
          profileBlob: JobProfileBlobDto(
              skills: List.from(
                  entity.skills!.map((skill) => SkillDto.fromJson(skill)))));
      // i want to implemet api here, which is called by usecase
      await _api.candidateControllerAddJobProfile(
          id: candidateId, addJobProfileDto: jobProfileDto);
      // No actual data operation in fake implementation
      return right(unit);
    } catch (error) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateItem(ProfileEntity entity) async {
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
}
