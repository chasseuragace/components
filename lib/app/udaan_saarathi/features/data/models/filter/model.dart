import '../../../domain/entities/filter/entity.dart';

class FilterModel extends FilterEntity {
  FilterModel({
    required super.id,
    required super.name,
    required Map<String, dynamic> super.rawJson,
  });

  factory FilterModel.fromJson(Map<String, dynamic> json) {
    return FilterModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Filter Template',
      rawJson: json,
    );
  }

  Map<String, dynamic> toJson() {
    return Map<String, dynamic>.from(rawJson);
  }
}
