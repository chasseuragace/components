import 'package:dartz/dartz.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/applicaitons/apply_job_d_t_o_entity.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../entities/applicaitons/entity.dart';
import '../../repositories/applicaitons/repository.dart';

class ApplyJobUseCase implements UseCase<Unit, ApplyJobDTOEntity> {
  final ApplicaitonsRepository repository;

  ApplyJobUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(ApplyJobDTOEntity entity) async {
    return repository.applyJob(entity);
  }
}
