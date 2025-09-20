import 'package:dartz/dartz.dart';
import '../../repositories/interviews/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class DeleteInterviewsUseCase implements UseCase<Unit, String> {
  final InterviewsRepository repository;

  DeleteInterviewsUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String id) async {
    return  repository.deleteItem(id);
  }
}
