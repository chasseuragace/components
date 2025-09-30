import 'package:dartz/dartz.dart';

import '../../entities/applicaitons/entity.dart';
import '../../repositories/applicaitons/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class GetApplicaitonsByIdUseCase implements UseCase<ApplicationDetailsEntity, String> {
  final ApplicaitonsRepository repository;

  GetApplicaitonsByIdUseCase(this.repository);

  @override
  Future<Either<Failure, ApplicationDetailsEntity>> call(String id) async {
    return  repository.getItemById(id);
  }
}
