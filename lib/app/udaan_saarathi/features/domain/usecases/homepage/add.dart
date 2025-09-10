import 'package:dartz/dartz.dart';
import '../../entities/homepage/entity.dart';
import '../../repositories/homepage/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class AddHomepageUseCase implements UseCase<Unit, HomepageEntity> {
  final HomepageRepository repository;

  AddHomepageUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(HomepageEntity entity) async {
    return  repository.addItem(entity);
  }
}
