import 'package:dartz/dartz.dart';
import '../../repositories/applicaitons/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class DeleteApplicaitonsUseCase implements UseCase<Unit, String> {
  final ApplicaitonsRepository repository;

  DeleteApplicaitonsUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String id) async {
    return  repository.deleteItem(id);
  }
}
