import '../../base_entity.dart';

abstract class FilterEntity extends BaseEntity {
  final String id;
  final String name;
  
  FilterEntity({
    required super.rawJson,
    required this.id,
    required this.name,
  });
}
