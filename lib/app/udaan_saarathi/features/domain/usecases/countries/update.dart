import 'package:dartz/dartz.dart';
import '../../entities/Countries/entity.dart';
import '../../repositories/Countries/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class UpdateCountriesUseCase implements UseCase<Unit, CountriesEntity> {
  final CountriesRepository repository;

  UpdateCountriesUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(CountriesEntity entity) async {
    return  repository.updateItem(entity);
  }
}
