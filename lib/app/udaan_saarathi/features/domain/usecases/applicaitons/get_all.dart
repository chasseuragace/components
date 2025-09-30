import 'package:dartz/dartz.dart';
import '../../entities/applicaitons/entity.dart';
import '../../repositories/applicaitons/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class GetAllApplicaitonsUseCase implements UseCase<ApplicationPaginationWrapper, NoParm> {
  final ApplicaitonsRepository repository;

  GetAllApplicaitonsUseCase (this.repository);

  @override
  Future<Either<Failure,ApplicationPaginationWrapper>> call(NoParm params) async {
    return  repository.getAllItems();
  }
}
