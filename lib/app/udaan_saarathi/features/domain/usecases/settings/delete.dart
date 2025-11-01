import 'package:dartz/dartz.dart';
import '../../repositories/Settings/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class DeleteSettingsUseCase implements UseCase<Unit, String> {
  final SettingsRepository repository;

  DeleteSettingsUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String id) async {
    return  repository.deleteItem(id);
  }
}
