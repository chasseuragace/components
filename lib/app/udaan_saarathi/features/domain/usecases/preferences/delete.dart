import 'package:dartz/dartz.dart';
import '../../repositories/preferences/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class DeletePreferencesUseCase implements UseCase<Unit, String> {
  final PreferencesRepository repository;

  DeletePreferencesUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String id) async {
    return  repository.deleteItem(id);
  }
}
