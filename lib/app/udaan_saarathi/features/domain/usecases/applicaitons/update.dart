import 'package:dartz/dartz.dart';
import '../../entities/applicaitons/entity.dart';
import '../../repositories/applicaitons/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class UpdateApplicaitonsUseCase implements UseCase<Unit, ApplicaitonsEntity> {
  final ApplicaitonsRepository repository;

  UpdateApplicaitonsUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(ApplicaitonsEntity entity) async {
    return  repository.updateItem(entity);
  }
}
