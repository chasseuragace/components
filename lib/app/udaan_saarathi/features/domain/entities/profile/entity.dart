// abstract class ProfileEntity extends BaseEntity {
//   final String id;
//   ProfileEntity({
//         // TODO : Profile : Define params
//         required super.rawJson,
//         required this.id,
//         });
// }
class ProfileEntity {
  final List<Map<String, dynamic>>? skills;
  ProfileEntity({
    this.skills,
  });
}
