import 'package:dartz/dartz.dart';
import '../../entities/search/entity.dart';
import '../../repositories/search/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class GetSearchByIdUseCase implements UseCase<SearchEntity?, String> {
  final SearchRepository repository;

  GetSearchByIdUseCase(this.repository);

  @override
  Future<Either<Failure, SearchEntity?>> call(String id) async {
    return  repository.getItemById(id);
  }
}
