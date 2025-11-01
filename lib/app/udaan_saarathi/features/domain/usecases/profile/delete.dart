import 'package:dartz/dartz.dart';
import '../../repositories/profile/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class DeleteProfileUseCase implements UseCase<Unit, String> {
  final ProfileRepository repository;

  DeleteProfileUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String id) async {
    return  repository.deleteItem(id);
  }
}
