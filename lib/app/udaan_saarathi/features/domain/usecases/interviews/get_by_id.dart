import 'package:dartz/dartz.dart';
import '../../entities/interviews/entity.dart';
import '../../repositories/interviews/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class GetInterviewsByIdUseCase implements UseCase<InterviewsEntity?, String> {
  final InterviewsRepository repository;

  GetInterviewsByIdUseCase(this.repository);

  @override
  Future<Either<Failure, InterviewsEntity?>> call(String id) async {
    return  repository.getItemById(id);
  }
}
