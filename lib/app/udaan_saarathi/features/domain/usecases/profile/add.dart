import 'package:dartz/dartz.dart';
import '../../entities/profile/entity.dart';
import '../../repositories/profile/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class AddProfileUseCase implements UseCase<Unit, ProfileEntity> {
  final ProfileRepository repository;

  AddProfileUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(ProfileEntity entity) async {
    return  repository.addItem(entity);
  }
}
