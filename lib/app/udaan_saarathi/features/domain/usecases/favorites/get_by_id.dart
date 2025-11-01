import 'package:dartz/dartz.dart';
import '../../entities/Favorites/entity.dart';
import '../../repositories/Favorites/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class GetFavoritesByIdUseCase implements UseCase<FavoritesEntity?, String> {
  final FavoritesRepository repository;

  GetFavoritesByIdUseCase(this.repository);

  @override
  Future<Either<Failure, FavoritesEntity?>> call(String id) async {
    return  repository.getItemById(id);
  }
}
