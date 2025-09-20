import 'package:dartz/dartz.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/errors/failures.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/usecases/usecase.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/candidate/entity.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/repositories/candidate/repository.dart';

class GetCandidateAnalytics implements UseCase<CandidateStatisticsEntity?, NoParm> {
  final CandidateRepository repository;

  GetCandidateAnalytics(this.repository);

  @override
  Future<Either<Failure, CandidateStatisticsEntity?>> call(NoParm param) async {
    return  repository.getCandidateAnalytycs();
  }
}
