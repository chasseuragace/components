import 'package:dartz/dartz.dart';
import '../../entities/notification/entity.dart';
import '../../repositories/notification/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class GetNotificationsUseCase implements UseCase<NotificationListResult, GetNotificationsParams> {
  final NotificationRepository repository;

  GetNotificationsUseCase(this.repository);

  @override
  Future<Either<Failure, NotificationListResult>> call(GetNotificationsParams params) async {
    return repository.getNotifications(params);
  }
}
