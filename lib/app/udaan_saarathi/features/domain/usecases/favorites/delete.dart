import 'package:dartz/dartz.dart';
import '../../repositories/Favorites/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class DeleteFavoritesUseCase implements UseCase<Unit, String> {
  final FavoritesRepository repository;

  DeleteFavoritesUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String id) async {
    return  repository.deleteItem(id);
  }
}
