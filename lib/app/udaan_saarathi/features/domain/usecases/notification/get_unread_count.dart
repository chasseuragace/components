import 'package:dartz/dartz.dart';
import '../../repositories/notification/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class GetUnreadCountUseCase implements UseCase<int, NoParm> {
  final NotificationRepository repository;

  GetUnreadCountUseCase(this.repository);

  @override
  Future<Either<Failure, int>> call(NoParm params) async {
    return repository.getUnreadCount();
  }
}
