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
      print('Error getting all items: $error');
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
      final candidateId = await _storage.getCandidateId();
      if (candidateId == null) return left(ServerFailure());
      
      final jobProfileDto = UpdateJobProfileDto(
        profileBlob: JobProfileBlobDto(
          education: entity.profileBlob?.education
              ?.map((education) => EducationDto(
                    degree: education.degree ?? '',
                    institute: education.institute,
                    title: education.title ?? '',
                  ))
              .toList(),
          trainings: entity.profileBlob?.trainings
              ?.map((training) => TrainingDto(
                    title: training.title ?? '',
                    provider: training.provider,
                    hours: training.hours,
                    certificate: training.certificate,
                  ))
              .toList(),
          skills: entity.profileBlob?.skills
              ?.map((skill) => SkillDto(
                    title: skill.title ?? '',
                    durationMonths: skill.durationMonths,
                    years: skill.years,
                    documents: skill.documents,
                  ))
              .toList(),
          experience: entity.profileBlob?.experience
              ?.map((exp) => ExperienceDto(
                    title: exp.title ?? '',
                    employer: exp.employer,
                    startDateAd: exp.startDateAd,
                    endDateAd: exp.endDateAd,
                    months: exp.months,
                    description: exp.description,
                  ))
              .toList() ,
        ),
      );
      
      final response = await _api.candidateControllerUpdateJobProfile(
        id: candidateId,
        updateJobProfileDto: jobProfileDto,
      );
      
      // Validate response status with null safety
      if (response.statusCode == null || response.statusCode! < 200 || response.statusCode! >= 300) {
        print('Failed to add job profile: ${response.statusMessage}');
        return left(ServerFailure());
      }
      
      return right(unit);
    } catch (error) {
      print('Error adding job profile: $error');
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
      print('Error updating item: $error');
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
      print('Error deleting item: $error');
      return left(ServerFailure());
    }
  }
}
