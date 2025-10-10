import 'package:dartz/dartz.dart';
import '../../entities/Agency/entity.dart';
import '../../repositories/Agency/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class GetAgencyByIdUseCase implements UseCase<AgencyEntity?, String> {
  final AgencyRepository repository;

  GetAgencyByIdUseCase(this.repository);

  @override
  Future<Either<Failure, AgencyEntity?>> call(String id) async {
    return  repository.getItemById(id);
  }
}
