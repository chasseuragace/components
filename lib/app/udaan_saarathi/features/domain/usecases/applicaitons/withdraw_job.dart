import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../repositories/applicaitons/repository.dart';

class WithdrawJobUseCase implements UseCase<Unit, String> {
  final ApplicaitonsRepository repository;

  WithdrawJobUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String id) async {
    return repository.withdrawJob(id);
  }
}
