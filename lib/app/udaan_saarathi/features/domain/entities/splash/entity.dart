
import '../../base_entity.dart';

abstract class SplashEntity extends BaseEntity {
  final String id;
  SplashEntity({
        // TODO : Splash : Define params
        required super.rawJson,
        required this.id,
        });
}
