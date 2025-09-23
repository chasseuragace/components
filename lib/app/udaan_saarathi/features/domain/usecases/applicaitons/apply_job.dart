import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../entities/applicaitons/entity.dart';
import '../../repositories/applicaitons/repository.dart';

class ApplyJobUseCase implements UseCase<Unit, ApplicationEntity> {
  final ApplicaitonsRepository repository;

  ApplyJobUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(ApplicationEntity entity) async {
    return repository.applyJob(entity);
  }
}
