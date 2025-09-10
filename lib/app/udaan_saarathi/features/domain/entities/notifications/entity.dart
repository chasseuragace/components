
import '../../base_entity.dart';

abstract class NotificationsEntity extends BaseEntity {
  final String id;
  NotificationsEntity({
        // TODO : Notifications : Define params
        required super.rawJson,
        required this.id,
        });
}
