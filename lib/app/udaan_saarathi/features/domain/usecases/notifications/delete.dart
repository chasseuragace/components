import 'package:dartz/dartz.dart';
import '../../repositories/notifications/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class DeleteNotificationsUseCase implements UseCase<Unit, String> {
  final NotificationsRepository repository;

  DeleteNotificationsUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String id) async {
    return  repository.deleteItem(id);
  }
}
