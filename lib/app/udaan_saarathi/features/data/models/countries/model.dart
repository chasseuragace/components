import '../../../domain/entities/countries/entity.dart';

class CountriesModel extends CountriesEntity {
  CountriesModel({required super.id, required super.name, required super.rawJson});

  factory CountriesModel.fromJson(Map<String, dynamic> json) {
    return CountriesModel(
      id: json['id'] as String,
        name: json['name'] as String,
        rawJson: json, // Pass the entire JSON object
      );
  }
  


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
