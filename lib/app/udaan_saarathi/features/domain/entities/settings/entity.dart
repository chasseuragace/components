
import '../../base_entity.dart';

abstract class SettingsEntity extends BaseEntity {
  final String id;
  SettingsEntity({
        // TODO : Settings : Define params
        required super.rawJson,
        required this.id,
        });
}
