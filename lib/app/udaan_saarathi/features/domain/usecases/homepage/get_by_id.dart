import 'package:dartz/dartz.dart';
import '../../entities/homepage/entity.dart';
import '../../repositories/homepage/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class GetHomepageByIdUseCase implements UseCase<HomepageEntity?, String> {
  final HomepageRepository repository;

  GetHomepageByIdUseCase(this.repository);

  @override
  Future<Either<Failure, HomepageEntity?>> call(String id) async {
    return  repository.getItemById(id);
  }
}
