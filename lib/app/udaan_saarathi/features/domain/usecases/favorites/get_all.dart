import 'package:dartz/dartz.dart';
import '../../entities/Favorites/entity.dart';
import '../../repositories/Favorites/repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class GetAllFavoritesUseCase implements UseCase<List<FavoritesEntity>, NoParm> {
  final FavoritesRepository repository;

  GetAllFavoritesUseCase (this.repository);

  @override
  Future<Either<Failure, List<FavoritesEntity>>> call(NoParm params) async {
    return  repository.getAllItems();
  }
}
