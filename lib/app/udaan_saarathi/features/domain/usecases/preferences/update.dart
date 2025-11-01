import 'package:dartz/dartz.dart';
import '../../entities/preferences/entity.dart';
import '../../repositories/preferences/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class UpdatePreferencesUseCase implements UseCase<Unit, PreferencesEntity> {
  final PreferencesRepository repository;

  UpdatePreferencesUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(PreferencesEntity entity) async {
    return  repository.updateItem(entity);
  }
}
