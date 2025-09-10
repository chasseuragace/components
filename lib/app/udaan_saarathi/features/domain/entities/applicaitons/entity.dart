
import '../../base_entity.dart';

abstract class ApplicaitonsEntity extends BaseEntity {
  final String id;
  ApplicaitonsEntity({
        // TODO : Applicaitons : Define params
        required super.rawJson,
        required this.id,
        });
}
