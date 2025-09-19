import 'package:dartz/dartz.dart';
import 'package:openapi/openapi.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/config/api_config.dart';
import '../../../../core/errors/failures.dart';
import '../../../domain/entities/candidate/entity.dart';
import '../../../domain/repositories/candidate/repository.dart';
import '../../datasources/candidate/local_data_source.dart';
import '../../datasources/candidate/remote_data_source.dart';
import '../../models/candidate/model.dart';
import '../auth/token_storage.dart';

class CandidateRepositoryFake implements CandidateRepository {
  final CandidatesApi api = ApiConfig.client().getCandidatesApi();
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
      final candidateId =  (await _storage.getCandidateId()) ?? '';
      if (candidateId.isEmpty) {
        return left(ServerFailure());
      }
      final res = await api.candidateControllerGetCandidateProfile(id: candidateId);
      final dto = res.data;
      if (dto == null) return right(null);
      final model = CandidateModel.fromJson(dto.toJson());
      return right(model);
    } catch (error) {
      return left(ServerFailure());
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
      final body = CandidateUpdateDto(
        fullName: entity.fullName,
      
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
      // Use stored candidate id; UI need not supply it
      final candidateId = (await _storage.getCandidateId()) ?? '';
      if (candidateId.isEmpty) return left(ServerFailure());
      await api.candidateControllerUpdateCandidateProfile(
        id: candidateId,
        candidateUpdateDto: body,
      );
      return right(unit);
    } catch (error,s) {
      print(error );
      print(s );
      return left(ServerFailure());
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
