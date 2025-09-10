import 'package:dartz/dartz.dart';
import '../../repositories/search/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class DeleteSearchUseCase implements UseCase<Unit, String> {
  final SearchRepository repository;

  DeleteSearchUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String id) async {
    return  repository.deleteItem(id);
  }
}
