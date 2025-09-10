import 'package:dartz/dartz.dart';
import '../../entities/search/entity.dart';
import '../../repositories/search/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class UpdateSearchUseCase implements UseCase<Unit, SearchEntity> {
  final SearchRepository repository;

  UpdateSearchUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(SearchEntity entity) async {
    return  repository.updateItem(entity);
  }
}
