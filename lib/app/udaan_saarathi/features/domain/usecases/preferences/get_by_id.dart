import 'package:dartz/dartz.dart';
import '../../entities/preferences/entity.dart';
import '../../repositories/preferences/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class GetPreferencesByIdUseCase implements UseCase<PreferencesEntity?, String> {
  final PreferencesRepository repository;

  GetPreferencesByIdUseCase(this.repository);

  @override
  Future<Either<Failure, PreferencesEntity?>> call(String id) async {
    return  repository.getItemById(id);
  }
}
