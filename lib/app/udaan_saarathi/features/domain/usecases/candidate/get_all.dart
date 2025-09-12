import 'package:dartz/dartz.dart';
import '../../entities/candidate/entity.dart';
import '../../repositories/candidate/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class GetAllCandidateUseCase implements UseCase<List<CandidateEntity>, NoParm> {
  final CandidateRepository repository;

  GetAllCandidateUseCase (this.repository);

  @override
  Future<Either<Failure, List<CandidateEntity>>> call(NoParm params) async {
    return  repository.getAllItems();
  }
}
