import 'package:variant_dashboard/app/udaan_saarathi/features/data/models/applicaitons/model.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/applicaitons/entity.dart';

/// Model for paginated application results with JSON serialization
class ApplicationPaginationWrapperModel extends ApplicationPaginationWrapper {
  ApplicationPaginationWrapperModel({
    required super.items,
    super.total,
    super.page,
    super.limit,
  });

  factory ApplicationPaginationWrapperModel.fromJson(
      Map<String, dynamic> json) {
    return ApplicationPaginationWrapperModel(
      items: (json['items'] as List<dynamic>)
          .map((e) => ApplicaitonsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int?,
      page: json['page'] as int?,
      limit: json['limit'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((e) => (e as ApplicaitonsModel).toJson()).toList(),
      'total': total,
      'page': page,
      'limit': limit,
    };
  }
}

