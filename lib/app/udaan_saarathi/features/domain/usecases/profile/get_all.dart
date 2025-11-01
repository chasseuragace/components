import 'package:dartz/dartz.dart';
import '../../entities/profile/entity.dart';
import '../../repositories/profile/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class GetAllProfileUseCase implements UseCase<List<ProfileEntity>, NoParm> {
  final ProfileRepository repository;

  GetAllProfileUseCase (this.repository);

  @override
  Future<Either<Failure, List<ProfileEntity>>> call(NoParm params) async {
    return  repository.getAllItems();
  }
}
