import '../../../domain/entities/search/entity.dart';

class SearchModel extends SearchEntity {
  SearchModel({required super.id, this.name, required super.rawJson});

  factory SearchModel.fromJson(Map<String, dynamic> json) {
    return SearchModel(
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
