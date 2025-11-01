import '../../../domain/entities/Favorites/entity.dart';

class FavoritesModel extends FavoritesEntity {
  FavoritesModel({required super.id, this.name, required super.rawJson});

  factory FavoritesModel.fromJson(Map<String, dynamic> json) {
    return FavoritesModel(
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
