import 'package:dartz/dartz.dart';
import '../../entities/Settings/entity.dart';
import '../../repositories/Settings/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class GetAllSettingsUseCase implements UseCase<List<SettingsEntity>, NoParm> {
  final SettingsRepository repository;

  GetAllSettingsUseCase (this.repository);

  @override
  Future<Either<Failure, List<SettingsEntity>>> call(NoParm params) async {
    return  repository.getAllItems();
  }
}
