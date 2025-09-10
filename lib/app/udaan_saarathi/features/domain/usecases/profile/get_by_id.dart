import 'package:dartz/dartz.dart';
import '../../entities/profile/entity.dart';
import '../../repositories/profile/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class GetProfileByIdUseCase implements UseCase<ProfileEntity?, String> {
  final ProfileRepository repository;

  GetProfileByIdUseCase(this.repository);

  @override
  Future<Either<Failure, ProfileEntity?>> call(String id) async {
    return  repository.getItemById(id);
  }
}
