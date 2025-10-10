import 'package:dartz/dartz.dart';
import '../../entities/Agency/entity.dart';
import '../../repositories/Agency/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class GetAllAgencyUseCase implements UseCase<List<AgencyEntity>, NoParm> {
  final AgencyRepository repository;

  GetAllAgencyUseCase (this.repository);

  @override
  Future<Either<Failure, List<AgencyEntity>>> call(NoParm params) async {
    return  repository.getAllItems();
  }
}
