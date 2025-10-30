import 'package:dartz/dartz.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/applicaitons/application_details_entity.dart';

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
