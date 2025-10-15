import 'package:dartz/dartz.dart';
import '../../entities/Settings/entity.dart';
import '../../repositories/Settings/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class GetSettingsByIdUseCase implements UseCase<SettingsEntity?, String> {
  final SettingsRepository repository;

  GetSettingsByIdUseCase(this.repository);

  @override
  Future<Either<Failure, SettingsEntity?>> call(String id) async {
    return  repository.getItemById(id);
  }
}
