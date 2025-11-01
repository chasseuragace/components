import 'package:dartz/dartz.dart';
import '../../entities/Agency/entity.dart';
import '../../repositories/Agency/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class AddAgencyUseCase implements UseCase<Unit, AgencyEntity> {
  final AgencyRepository repository;

  AddAgencyUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(AgencyEntity entity) async {
    return  repository.addItem(entity);
  }
}
