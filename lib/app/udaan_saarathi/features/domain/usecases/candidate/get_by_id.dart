import 'package:dartz/dartz.dart';
import '../../entities/candidate/entity.dart';
import '../../repositories/candidate/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class GetCandidateByIdUseCase implements UseCase<CandidateEntity?, NoParm> {
  final CandidateRepository repository;

  GetCandidateByIdUseCase(this.repository);

  @override
  Future<Either<Failure, CandidateEntity?>> call(NoParm param) async {
    return  repository.getItemById();
  }
}
