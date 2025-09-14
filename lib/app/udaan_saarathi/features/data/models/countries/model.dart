import '../../../domain/entities/Countries/entity.dart';

class CountriesModel extends CountriesEntity {
  CountriesModel({required super.id, this.name, required super.rawJson});

  factory CountriesModel.fromJson(Map<String, dynamic> json) {
    return CountriesModel(
      id: json['id'] as String,
        name: json['name'] as String?,
        rawJson: json, // Pass the entire JSON object
      );
  }
  
  final String? name;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
