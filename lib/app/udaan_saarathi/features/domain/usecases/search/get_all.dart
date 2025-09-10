import 'package:dartz/dartz.dart';
import '../../entities/search/entity.dart';
import '../../repositories/search/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class GetAllSearchUseCase implements UseCase<List<SearchEntity>, NoParm> {
  final SearchRepository repository;

  GetAllSearchUseCase (this.repository);

  @override
  Future<Either<Failure, List<SearchEntity>>> call(NoParm params) async {
    return  repository.getAllItems();
  }
}
