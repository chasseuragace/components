
import '../../base_entity.dart';

abstract class CountriesEntity extends BaseEntity {
  final String id;
  CountriesEntity({
        // TODO : Countries : Define params
        required super.rawJson,
        required this.id,
        });
}
