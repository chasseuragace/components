import 'package:dartz/dartz.dart';
import '../../repositories/Agency/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class DeleteAgencyUseCase implements UseCase<Unit, String> {
  final AgencyRepository repository;

  DeleteAgencyUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String id) async {
    return  repository.deleteItem(id);
  }
}
