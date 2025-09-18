import 'package:dartz/dartz.dart';
import 'package:openapi/openapi.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/config/api_config.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/data/models/profile/model.dart';
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
    try {
      // Simulate delay
      final candidateId = await _storage.getCandidateId();
      if (candidateId == null) {
        return left(ServerFailure());
      }
     
      // i want to implemet api here, which is called by usecase
    final response =  await _api.candidateControllerListJobProfiles(
          id: candidateId,);
      // No actual data operation in fake implementation
      CandidateJobProfileDto? profileData= response.data?.firstOrNull;
    if(profileData==null) return right(<ProfileEntity>[]);
      ProfileEntity data = ProfileModel.fromJson(profileData.toJson());
      return right([data]);
    } catch (error) {
      print(error);
      return left(ServerFailure());
    }

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
              skills: entity.profileBlob?.skills?.map((skill) => 
                  SkillDto(
                    title: skill.title ?? '',
                    durationMonths: skill.durationMonths,
                    years: skill.years,
                    documents: skill.documents,
                  )).toList() ?? []));
      // i want to implemet api here, which is called by usecase
      await _api.candidateControllerAddJobProfile(
          id: candidateId, addJobProfileDto: jobProfileDto);
      // No actual data operation in fake implementation
      return right(unit);
    } catch (error) {
      print("error: $error");
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
