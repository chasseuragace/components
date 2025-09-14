import 'package:dartz/dartz.dart';
import '../../repositories/Countries/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class DeleteCountriesUseCase implements UseCase<Unit, String> {
  final CountriesRepository repository;

  DeleteCountriesUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String id) async {
    return  repository.deleteItem(id);
  }
}
