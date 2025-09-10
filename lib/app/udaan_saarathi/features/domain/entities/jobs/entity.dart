
import '../../base_entity.dart';

abstract class JobsEntity extends BaseEntity {
  final String id;
  JobsEntity({
        // TODO : Jobs : Define params
        required super.rawJson,
        required this.id,
        });
}
