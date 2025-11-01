import 'package:dartz/dartz.dart';
import '../../repositories/job_title/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class DeleteJobTitleUseCase implements UseCase<Unit, String> {
  final JobTitleRepository repository;

  DeleteJobTitleUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String id) async {
    return  repository.deleteItem(id);
  }
}
