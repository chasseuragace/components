
import '../../base_entity.dart';

abstract class HomepageEntity extends BaseEntity {
  final String id;
  HomepageEntity({
        // TODO : Homepage : Define params
        required super.rawJson,
        required this.id,
        });
}
