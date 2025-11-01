import 'package:dartz/dartz.dart';
import 'package:openapi/openapi.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/config/api_config.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/data/repositories/auth/token_storage.dart';
import '../../../../core/errors/failures.dart';
import '../../../domain/entities/interviews/entity.dart';
import '../../../domain/repositories/interviews/repository.dart';
import '../../datasources/interviews/local_data_source.dart';
import '../../datasources/interviews/remote_data_source.dart';
import '../../models/interviews/model.dart';
// Fake data for Interviewss
class InterviewsRepositoryFake implements InterviewsRepository {
  final InterviewsLocalDataSource localDataSource;
  final InterviewsRemoteDataSource remoteDataSource;
  final TokenStorage storage;
final api =ApiConfig.client().getCandidatesApi();
  InterviewsRepositoryFake( {
    required this.localDataSource,
    required this.remoteDataSource,
   required  this.storage,
  });

  @override
  Future<Either<Failure, InterviewsPaginationEntity>> getAllItems({
    required int page,
    required int limit,
  }) async {
    try {
 final candidateId =  (await storage.getCandidateId()) ?? '';
      if (candidateId.isEmpty) {
        return left(ServerFailure());
      }
      final remote = await api.candidateControllerListInterviews(id: candidateId);

      final PaginatedInterviewsDto payload = remote.data!;
  


     
      final pagination = InterviewsPaginationModel.fromJson(
       payload.toJson()
      );

      return right(pagination);
    } catch (error) {

      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, InterviewsEntity?>> getItemById(String id) async {
    try {
      final candidateId = (await storage.getCandidateId()) ?? '';
      if (candidateId.isEmpty) {
        return left(ServerFailure());
      }

      final remote = await api.candidateControllerListInterviews(id: candidateId);
      final dynamic payload = remote;
      List<dynamic> itemsDyn = const [];
      if (payload is Map) {
        final data = (payload['data'] is Map) ? payload['data'] as Map : payload;
        itemsDyn = (data['items'] as List?) ?? [];
      } else if (payload is List) {
        itemsDyn = payload;
      }

      final models = itemsDyn
          .whereType<Map<String, dynamic>>()
          .map((e) => InterviewsModel.fromJson(e))
          .toList();

      final match = models.firstWhere((m) => m.id == id, orElse: () => throw 'Not found');
      return right(match);
    } catch (error,s) {
      print(error);
      print(s);
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> addItem(InterviewsEntity entity) async {
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
  Future<Either<Failure, Unit>> updateItem(InterviewsEntity entity) async {
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
