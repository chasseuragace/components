import 'package:dartz/dartz.dart';
import '../../entities/notifications/entity.dart';
import '../../repositories/notifications/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class GetAllNotificationsUseCase implements UseCase<List<NotificationsEntity>, NoParm> {
  final NotificationsRepository repository;

  GetAllNotificationsUseCase (this.repository);

  @override
  Future<Either<Failure, List<NotificationsEntity>>> call(NoParm params) async {
    return  repository.getAllItems();
  }
}
