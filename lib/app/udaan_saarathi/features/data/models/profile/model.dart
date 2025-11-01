import '../../../domain/entities/profile/entity.dart';

// Nested models
class SkillModel extends SkillEntity {
  SkillModel({
    super.title,
    super.durationMonths,
    super.years,
    super.documents,
  });

  factory SkillModel.fromJson(Map<String, dynamic> json) {
    return SkillModel(
      title: json['title'] as String?,
      durationMonths: json['duration_months'] as int?,
      years: json['years'] as int?,
      documents: (json['documents'] as List<dynamic>?)?.cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'duration_months': durationMonths,
      'years': years,
      'documents': documents,
    };
  }
}

class EducationModel extends EducationEntity {
  EducationModel({
    super.title,
    super.institute,
    super.degree,
    super.document,
  });

  factory EducationModel.fromJson(Map<String, dynamic> json) {
    return EducationModel(
      title: json['title'] as String?,
      institute: json['institute'] as String?,
      degree: json['degree'] as String?,
      document: json['document'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'institute': institute,
      'degree': degree,
      'document': document,
    };
  }
}

class TrainingModel extends TrainingEntity {
  TrainingModel({
    super.title,
    super.provider,
    super.hours,
    super.certificate,
  });

  factory TrainingModel.fromJson(Map<String, dynamic> json) {
    return TrainingModel(
      title: json['title'] as String?,
      provider: json['provider'] as String?,
      hours: json['hours'] as int?,
      certificate: json['certificate'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'provider': provider,
      'hours': hours,
      'certificate': certificate,
    };
  }
}

class ExperienceModel extends ExperienceEntity {
  ExperienceModel({
    super.title,
    super.employer,
    super.startDateAd,
    super.endDateAd,
    super.months,
    super.description,
  });

  factory ExperienceModel.fromJson(Map<String, dynamic> json) {
    return ExperienceModel(
      title: json['title'] as String?,
      employer: json['employer'] as String?,
      startDateAd: json['start_date_ad'] as String?,
      endDateAd: json['end_date_ad'] as String?,
      months: json['months'] as int?,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'employer': employer,
      'start_date_ad': startDateAd,
      'end_date_ad': endDateAd,
      'months': months,
      'description': description,
    };
  }
}

class ProfileBlobModel extends ProfileBlobEntity {
  ProfileBlobModel({
    super.summary,
    super.skills,
    super.education,
    super.trainings,
    super.experience,
  });

  factory ProfileBlobModel.fromJson(Map<String, dynamic> json) {
    return ProfileBlobModel(
      summary: json['summary'] as String?,
      skills: (json['skills'] as List<dynamic>?)
          ?.map((e) => SkillModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      education: (json['education'] as List<dynamic>?)
          ?.map((e) => EducationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      trainings: (json['trainings'] as List<dynamic>?)
          ?.map((e) => TrainingModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      experience: (json['experience'] as List<dynamic>?)
          ?.map((e) => ExperienceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'summary': summary,
      'skills': skills?.map((e) => (e as SkillModel).toJson()).toList(),
      'education': education?.map((e) => (e as EducationModel).toJson()).toList(),
      'trainings': trainings?.map((e) => (e as TrainingModel).toJson()).toList(),
      'experience': experience?.map((e) => (e as ExperienceModel).toJson()).toList(),
    };
  }
}

class ProfileModel extends ProfileEntity {
  ProfileModel({
    super.id,
    super.candidateId,
    super.profileBlob,
    super.label,
    super.createdAt,
    super.updatedAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as String?,
      candidateId: json['candidate_id'] as String?,
      profileBlob: json['profile_blob'] != null
          ? ProfileBlobModel.fromJson(json['profile_blob'] as Map<String, dynamic>)
          : null,
      label: json['label'] as Map<String, dynamic>?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'candidate_id': candidateId,
      'profile_blob': (profileBlob as ProfileBlobModel?)?.toJson(),
      'label': label,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
