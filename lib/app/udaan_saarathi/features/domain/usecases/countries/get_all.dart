import 'package:dartz/dartz.dart';
import '../../entities/Countries/entity.dart';
import '../../repositories/Countries/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class GetAllCountriesUseCase implements UseCase<List<CountriesEntity>, NoParm> {
  final CountriesRepository repository;

  GetAllCountriesUseCase (this.repository);

  @override
  Future<Either<Failure, List<CountriesEntity>>> call(NoParm params) async {
    return  repository.getAllItems();
  }
}
