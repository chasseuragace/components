import 'package:dartz/dartz.dart';
import '../../entities/Settings/entity.dart';
import '../../repositories/Settings/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class AddSettingsUseCase implements UseCase<Unit, SettingsEntity> {
  final SettingsRepository repository;

  AddSettingsUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(SettingsEntity entity) async {
    return  repository.addItem(entity);
  }
}
