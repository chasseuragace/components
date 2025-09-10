import 'package:dartz/dartz.dart';
import '../../entities/preferences/entity.dart';
import '../../repositories/preferences/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class GetAllPreferencesUseCase implements UseCase<List<PreferencesEntity>, NoParm> {
  final PreferencesRepository repository;

  GetAllPreferencesUseCase (this.repository);

  @override
  Future<Either<Failure, List<PreferencesEntity>>> call(NoParm params) async {
    return  repository.getAllItems();
  }
}
