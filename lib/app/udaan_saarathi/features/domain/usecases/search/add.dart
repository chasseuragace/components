import 'package:dartz/dartz.dart';
import '../../entities/search/entity.dart';
import '../../repositories/search/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class AddSearchUseCase implements UseCase<Unit, SearchEntity> {
  final SearchRepository repository;

  AddSearchUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(SearchEntity entity) async {
    return  repository.addItem(entity);
  }
}
