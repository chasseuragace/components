import 'package:dartz/dartz.dart';
import '../../repositories/notification/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class MarkAllAsReadUseCase implements UseCase<int, NoParm> {
  final NotificationRepository repository;

  MarkAllAsReadUseCase(this.repository);

  @override
  Future<Either<Failure, int>> call(NoParm params) async {
    return repository.markAllAsRead();
  }
}
