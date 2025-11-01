import 'package:dartz/dartz.dart';
import '../../entities/jobs/entity.dart';
import '../../entities/jobs/entity_mobile.dart';
import '../../repositories/jobs/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class GetJobsByIdUseCase implements UseCase<MobileJobEntity?, String> {
  final JobsRepository repository;

  GetJobsByIdUseCase(this.repository);

  @override
  Future<Either<Failure, MobileJobEntity?>> call(String id) async {
    return  repository.getItemById(id);
  }
}
