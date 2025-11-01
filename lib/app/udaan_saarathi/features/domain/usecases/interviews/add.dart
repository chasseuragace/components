import 'package:dartz/dartz.dart';
import '../../entities/interviews/entity.dart';
import '../../repositories/interviews/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class AddInterviewsUseCase implements UseCase<Unit, InterviewsEntity> {
  final InterviewsRepository repository;

  AddInterviewsUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(InterviewsEntity entity) async {
    return  repository.addItem(entity);
  }
}
