import 'package:dartz/dartz.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/applicaitons/application_details_entity.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/applicaitons/application_pagination_wrapper.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/applicaitons/apply_job_d_t_o_entity.dart';
import '../../entities/applicaitons/entity.dart';
import '../../../../core/errors/failures.dart';

abstract class ApplicaitonsRepository {
  Future<Either<Failure, ApplicationPaginationWrapper>> getAllItems();
  Future<Either<Failure, ApplicationDetailsEntity>> getItemById(String id);

  Future<Either<Failure, Unit>> updateItem(ApplicaitonsEntity entity);
  Future<Either<Failure, Unit>> deleteItem(String id);
  Future<Either<Failure, Unit>> applyJob(ApplyJobDTOEntity entity);
  Future<Either<Failure, Unit>> withdrawJob(String id);
}
