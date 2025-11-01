import 'package:dartz/dartz.dart';
import '../../entities/notifications/entity.dart';
import '../../repositories/notifications/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class GetNotificationsByIdUseCase implements UseCase<NotificationsEntity?, String> {
  final NotificationsRepository repository;

  GetNotificationsByIdUseCase(this.repository);

  @override
  Future<Either<Failure, NotificationsEntity?>> call(String id) async {
    return  repository.getItemById(id);
  }
}
