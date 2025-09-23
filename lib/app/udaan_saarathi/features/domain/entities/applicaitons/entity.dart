
import '../../base_entity.dart';

abstract class ApplicaitonsEntity extends BaseEntity {
  final String id;
  ApplicaitonsEntity({
        // TODO : Applicaitons : Define params
        required super.rawJson,
        required this.id,
        });
}
class ApplicationEntity {
  final String candidateId;
  final String jobPostingId;
  final String note;
  final String updatedBy;

  ApplicationEntity({
    required this.candidateId,
    required this.jobPostingId,
    required this.note,
    required this.updatedBy,
  });
}
