import 'package:dartz/dartz.dart';
import '../../entities/countries/entity.dart';
import '../../repositories/countries/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class GetCountriesByIdUseCase implements UseCase<CountriesEntity?, String> {
  final CountriesRepository repository;

  GetCountriesByIdUseCase(this.repository);

  @override
  Future<Either<Failure, CountriesEntity?>> call(String id) async {
    return  repository.getItemById(id);
  }
}
