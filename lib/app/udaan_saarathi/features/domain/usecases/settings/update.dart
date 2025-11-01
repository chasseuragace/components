import 'package:dartz/dartz.dart';
import '../../entities/Settings/entity.dart';
import '../../repositories/Settings/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class UpdateSettingsUseCase implements UseCase<Unit, SettingsEntity> {
  final SettingsRepository repository;

  UpdateSettingsUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(SettingsEntity entity) async {
    return  repository.updateItem(entity);
  }
}
