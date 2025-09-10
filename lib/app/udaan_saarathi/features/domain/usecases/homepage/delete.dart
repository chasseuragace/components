import 'package:dartz/dartz.dart';
import '../../repositories/homepage/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class DeleteHomepageUseCase implements UseCase<Unit, String> {
  final HomepageRepository repository;

  DeleteHomepageUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String id) async {
    return  repository.deleteItem(id);
  }
}
