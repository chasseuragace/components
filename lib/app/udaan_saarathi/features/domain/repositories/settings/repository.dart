import 'package:dartz/dartz.dart';
import '../../entities/Settings/entity.dart';
import '../../../../core/errors/failures.dart';

abstract class SettingsRepository {
  Future<Either<Failure, List<SettingsEntity>>> getAllItems();
  Future<Either<Failure, SettingsEntity?>> getItemById(String id);
  Future<Either<Failure, Unit>> addItem(SettingsEntity entity);
  Future<Either<Failure, Unit>> updateItem(SettingsEntity entity);
  Future<Either<Failure, Unit>> deleteItem(String id);
}
