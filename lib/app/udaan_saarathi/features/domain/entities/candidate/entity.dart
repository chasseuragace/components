
import '../../base_entity.dart';

abstract class CandidateEntity extends BaseEntity {
  final String id;
  CandidateEntity({
        // TODO : Candidate : Define params
        required super.rawJson,
        required this.id,
        });
}
