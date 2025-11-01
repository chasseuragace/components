import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../repositories/Favorites/repository.dart';

class AddFavoritesUseCase implements UseCase<Unit, String> {
  final FavoritesRepository repository;

  AddFavoritesUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String jobId) async {
    return await repository.addItem(jobId: jobId);
  }
}
