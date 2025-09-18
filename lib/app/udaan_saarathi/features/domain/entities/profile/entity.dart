// Nested entities
class SkillEntity {
  final String? title;
  final int? durationMonths;
  final int? years;
  final List<String>? documents;

  SkillEntity({
    this.title,
    this.durationMonths,
    this.years,
    this.documents,
  });
}

class EducationEntity {
  final String? title;
  final String? institute;
  final String? degree;
  final String? document;

  EducationEntity({
    this.title,
    this.institute,
    this.degree,
    this.document,
  });
}

class TrainingEntity {
  final String? title;
  final String? provider;
  final int? hours;
  final bool? certificate;

  TrainingEntity({
    this.title,
    this.provider,
    this.hours,
    this.certificate,
  });
}

class ExperienceEntity {
  final String? title;
  final String? employer;
  final String? startDateAd;
  final String? endDateAd;
  final int? months;
  final String? description;

  ExperienceEntity({
    this.title,
    this.employer,
    this.startDateAd,
    this.endDateAd,
    this.months,
    this.description,
  });
}

class ProfileBlobEntity {
  final String? summary;
  final List<SkillEntity>? skills;
  final List<EducationEntity>? education;
  final List<TrainingEntity>? trainings;
  final List<ExperienceEntity>? experience;

  ProfileBlobEntity({
    this.summary,
    this.skills,
    this.education,
    this.trainings,
    this.experience,
  });
}

class ProfileEntity {
  final String? id;
  final String? candidateId;
  final ProfileBlobEntity? profileBlob;
  final Map<String, dynamic>? label;
  final String? createdAt;
  final String? updatedAt;

  ProfileEntity({
    this.id,
    this.candidateId,
    this.profileBlob,
    this.label,
    this.createdAt,
    this.updatedAt,
  });
}


/// this ishte json 
/// [
//   {
//     "id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
//     "candidate_id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
//     "profile_blob": {
//       "summary": "string",
//       "skills": [
//         {
//           "title": "string",
//           "duration_months": 0,
//           "years": 0,
//           "documents": [
//             "string"
//           ]
//         }
//       ],
//       "education": [
//         {
//           "title": "string",
//           "institute": "string",
//           "degree": "string",
//           "document": "string"
//         }
//       ],
//       "trainings": [
//         {
//           "title": "string",
//           "provider": "string",
//           "hours": 0,
//           "certificate": true
//         }
//       ],
//       "experience": [
//         {
//           "title": "string",
//           "employer": "string",
//           "start_date_ad": "string",
//           "end_date_ad": "string",
//           "months": 0,
//           "description": "string"
//         }
//       ]
//     },
//     "label": {},
//     "created_at": "string",
//     "updated_at": "string"
//   }
// ]