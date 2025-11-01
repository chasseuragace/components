import 'package:dartz/dartz.dart';
import '../../entities/interviews/entity.dart';
import '../../repositories/interviews/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class Pagination{
 int  page,take;
 Pagination({this. page=0, this. take=20});
}
class GetAllInterviewsUseCase implements UseCase<InterviewsPaginationEntity, Pagination> {
  final InterviewsRepository repository;

  GetAllInterviewsUseCase (this.repository);

  @override
  Future<Either<Failure, InterviewsPaginationEntity>> call(Pagination p ) async {
    return  repository.getAllItems(page: p.page,limit: p.take);
  }
}
