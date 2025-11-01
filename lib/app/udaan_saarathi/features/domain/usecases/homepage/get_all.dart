import 'package:dartz/dartz.dart';
import '../../entities/homepage/entity.dart';
import '../../repositories/homepage/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class GetAllHomepageUseCase implements UseCase<List<HomepageEntity>, NoParm> {
  final HomepageRepository repository;

  GetAllHomepageUseCase (this.repository);

  @override
  Future<Either<Failure, List<HomepageEntity>>> call(NoParm params) async {
    return  repository.getAllItems();
  }
}
