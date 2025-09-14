import 'package:dartz/dartz.dart';
import '../../entities/preferences/entity.dart';
import '../../../../core/errors/failures.dart';

abstract class PreferencesRepository {
  Future<Either<Failure, List<PreferencesEntity>>> getAllItems();
  Future<Either<Failure, PreferencesEntity?>> getItemById(String id);
  Future<Either<Failure, Unit>> addItem(PreferencesEntity entity);
  Future<Either<Failure, Unit>> updateItem(PreferencesEntity entity);
  Future<Either<Failure, Unit>> deleteItem(String id);
  
  /// Get user's filter/template data for pre-filling preferences
  Future<Either<Failure, Map<String, dynamic>?>> getFilter();
}
