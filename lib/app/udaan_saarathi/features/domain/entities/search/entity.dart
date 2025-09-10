
import '../../base_entity.dart';

abstract class SearchEntity extends BaseEntity {
  final String id;
  SearchEntity({
        // TODO : Search : Define params
        required super.rawJson,
        required this.id,
        });
}
