import '../../../domain/entities/Settings/entity.dart';

class SettingsModel extends SettingsEntity {
  SettingsModel({required super.id, this.name, required super.rawJson});

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
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
