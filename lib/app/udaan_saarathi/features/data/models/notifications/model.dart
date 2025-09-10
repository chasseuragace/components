import '../../../domain/entities/notifications/entity.dart';

class NotificationsModel extends NotificationsEntity {
  NotificationsModel({required super.id, this.name, required super.rawJson});

  factory NotificationsModel.fromJson(Map<String, dynamic> json) {
    return NotificationsModel(
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
