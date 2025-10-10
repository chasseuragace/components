
import '../../base_entity.dart';

abstract class AgencyEntity extends BaseEntity {
  final String id;
  AgencyEntity({
        // TODO : Agency : Define params
        required super.rawJson,
        required this.id,
        });
}
