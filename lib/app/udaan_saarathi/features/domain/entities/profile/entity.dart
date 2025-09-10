
import '../../base_entity.dart';

abstract class ProfileEntity extends BaseEntity {
  final String id;
  ProfileEntity({
        // TODO : Profile : Define params
        required super.rawJson,
        required this.id,
        });
}
