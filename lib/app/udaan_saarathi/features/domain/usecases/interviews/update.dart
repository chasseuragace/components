import 'package:dartz/dartz.dart';
import '../../entities/interviews/entity.dart';
import '../../repositories/interviews/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class UpdateInterviewsUseCase implements UseCase<Unit, InterviewsEntity> {
  final InterviewsRepository repository;

  UpdateInterviewsUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(InterviewsEntity entity) async {
    return  repository.updateItem(entity);
  }
}
