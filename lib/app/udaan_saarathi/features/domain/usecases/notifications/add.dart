import 'package:dartz/dartz.dart';
import '../../entities/notifications/entity.dart';
import '../../repositories/notifications/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class AddNotificationsUseCase implements UseCase<Unit, NotificationsEntity> {
  final NotificationsRepository repository;

  AddNotificationsUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(NotificationsEntity entity) async {
    return  repository.addItem(entity);
  }
}
