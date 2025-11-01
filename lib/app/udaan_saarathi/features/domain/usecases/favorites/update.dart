import 'package:dartz/dartz.dart';
import '../../entities/Favorites/entity.dart';
import '../../repositories/Favorites/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class UpdateFavoritesUseCase implements UseCase<Unit, FavoritesEntity> {
  final FavoritesRepository repository;

  UpdateFavoritesUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(FavoritesEntity entity) async {
    return  repository.updateItem(entity);
  }
}
