
import '../../base_entity.dart';

abstract class CountriesEntity extends BaseEntity {
  final String id;
  final String name;
  CountriesEntity({
        // TODO : Countries : Define params
        required super.rawJson,
        required this.id,
        required this.name,
        });
}
