import 'package:dartz/dartz.dart';
import '../../entities/homepage/entity.dart';
import '../../repositories/homepage/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class UpdateHomepageUseCase implements UseCase<Unit, HomepageEntity> {
  final HomepageRepository repository;

  UpdateHomepageUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(HomepageEntity entity) async {
    return  repository.updateItem(entity);
  }
}
