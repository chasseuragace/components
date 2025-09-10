
import '../../base_entity.dart';

abstract class PreferencesEntity extends BaseEntity {
  final String id;
  PreferencesEntity({
        // TODO : Preferences : Define params
        required super.rawJson,
        required this.id,
        });
}
