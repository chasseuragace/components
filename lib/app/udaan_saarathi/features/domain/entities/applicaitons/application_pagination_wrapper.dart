import 'package:collection/collection.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/applicaitons/entity.dart';

class ApplicationPaginationWrapper {
  final List<ApplicaitonsEntity> items;
  final int? total;
  final int? page;
  final int? limit;
  final bool isLoadingMore;

  const ApplicationPaginationWrapper({
    required this.items,
    this.total,
    this.page,
    this.limit,
    this.isLoadingMore = false,
  });

  bool get hasReachedEnd {
    if (total == null || limit == null) return false;
    return page != null && page! * limit! >= total!;
  }

  bool get hasData => items.isNotEmpty;

  bool get hasMoreToLoad {
    if (total == null || limit == null) return false;
    return page == null || page! * limit! < total!;
  }

  ApplicationPaginationWrapper copyWith({
    List<ApplicaitonsEntity>? items,
    int? total,
    int? page,
    int? limit,
    bool? isLoadingMore,
  }) {
    return ApplicationPaginationWrapper(
      items: items ?? this.items,
      total: total ?? this.total,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ApplicationPaginationWrapper &&
        other.runtimeType == runtimeType &&
        other.total == total &&
        other.page == page &&
        other.limit == limit &&
        other.isLoadingMore == isLoadingMore &&
        const DeepCollectionEquality().equals(other.items, items);
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, total, page, limit, isLoadingMore, items);
}

// id
// candidate_id
// job_posting_id
// status
// agency_name
// interview
// created_at
// updated_at




// interview is 
// 'id': instance.id,
//   'interview_date_ad': ?instance.interviewDateAd?.toIso8601String(),
//   'interview_date_bs': ?instance.interviewDateBs,
//   'interview_time': ?instance.interviewTime,
//   'location': ?instance.location,
//   'contact_person': ?instance.contactPerson,
//   'required_documents': ?instance.requiredDocuments,
//   'notes': ?instance.notes,
//   'expenses': ?instance.expenses?.map((e) => e.toJson()).toList(),


//   and expense is list of 
//    'expense_type': instance.expenseType,
//   'who_pays': instance.whoPays,
//   'is_free': instance.isFree,
//   'amount': ?instance.amount,
//   'currency': ?instance.currency,
//   'refundable': instance.refundable,
//   'notes': ?instance.notes,