
import '../../base_entity.dart';

abstract class FavoritesEntity extends BaseEntity {
  final String id;
  FavoritesEntity({
        // TODO : Favorites : Define params
        required super.rawJson,
        required this.id,
        });
}
