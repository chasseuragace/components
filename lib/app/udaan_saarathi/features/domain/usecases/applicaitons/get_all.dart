import 'package:dartz/dartz.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/applicaitons/application_pagination_wrapper.dart';
import '../../entities/applicaitons/entity.dart';
import '../../repositories/applicaitons/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import 'params.dart';

class GetAllApplicaitonsUseCase implements UseCase<ApplicationPaginationWrapper, GetAllApplicationsParams> {
  final ApplicaitonsRepository repository;

  const GetAllApplicaitonsUseCase(this.repository);

  @override
  Future<Either<Failure, ApplicationPaginationWrapper>> call(GetAllApplicationsParams params) async {
    return repository.getAllItems(
      page: params.page,
      status: params.status,
    );
  }
}
