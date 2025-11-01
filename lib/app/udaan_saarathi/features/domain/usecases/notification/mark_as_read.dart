import 'package:dartz/dartz.dart';
import '../../entities/notification/entity.dart';
import '../../repositories/notification/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class MarkAsReadUseCase implements UseCase<NotificationEntity?, String> {
  final NotificationRepository repository;

  MarkAsReadUseCase(this.repository);

  @override
  Future<Either<Failure, NotificationEntity?>> call(String id) async {
    return repository.markAsRead(id);
  }
}
