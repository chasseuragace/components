import 'package:variant_dashboard/app/udaan_saarathi/features/data/models/jobs/mobile_job_model.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/homepage/job_position.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/jobs/grouped_jobs.dart';
import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/variants/pages/home/job_posting.dart';

/// Functions to transform backend models (GroupedJobsModel, JobGroupModel, GroupJobModel)
/// into UI models (JobPosting, JobPosition) expected by widgets like JobPostingCard.
class JobPostingMapper {
  /// Map an entire GroupedJobsEntity -> List<JobPosting> (flatten all groups)
  static List<MobileJobEntity> fromGroupedJobs(GroupedJobsEntity entity) {
    return entity.groups
        .expand((group) => fromJobGroup(group))
        .toList(growable: false);
  }

  /// Map a group (JobGroupEntity) -> List<JobPosting>
  static List<MobileJobEntity> fromJobGroup(JobGroupEntity group) {
    return group.jobs.map((job) => fromGroupJob(job)).toList(growable: false);
  }

  /// Core mapping: GroupJobEntity -> JobPosting
  static MobileJobEntity fromGroupJob(GroupJobEntity job) {
    final positions = _positionsFromPrimaryTitles(job);

    final baseSalaryStr = _formatBaseSalary(job.salary);
    final convertedSalaryStr = _formatConvertedSalary(job.salary);

    // Preference chip text: prefer first primary title, else posting title
    final preferenceText = _buildPreferenceText(job);

    // Match percentage from fitnessScore if available
    final matchPct = job.fitnessScore > 0 ? '${job.fitnessScore}%' : null;

    return MobileJobEntity(
      id: job.id,
      postingTitle: job.postingTitle,
      country: job.country,
      city: job.city ?? '',
      agency: job.agency.name ?? '',
      employer: job.employer.companyName ?? '',
      positions: positions,
      description: _buildDescription(job, baseSalaryStr, convertedSalaryStr),
      contractTerms: _buildContractTerms(),
      isActive: true, // Backend field not provided, default to active
      postedDate: job.postingDateAd ?? DateTime.now(),
      preferencePriority: null, // Could be derived from fitness buckets later
      preferenceText: preferenceText,
      location: _composeLocation(job),
      experience: null,
      salary: baseSalaryStr,
      type: null,
      isRemote: null,
      isFeatured: null,
      companyLogo: job.cutoutUrl,
      matchPercentage: matchPct,
      convertedSalary: convertedSalaryStr,
      applications: null,
      policy: null,
    );
  }

  // --- Helpers ---

  static List<JobPosition> _positionsFromPrimaryTitles(GroupJobEntity job) {
    if (job.primaryTitles.isEmpty) {
      return [
        JobPosition(
          id: '${job.id}_0',
          title: job.postingTitle,
          baseSalary: _formatBaseSalary(job.salary),
          convertedSalary: _formatConvertedSalary(job.salary),
          currency: job.salary.currency,
          requirements: const [],
        )
      ];
    }

    final baseSalary = _formatBaseSalary(job.salary);
    final convertedSalary = _formatConvertedSalary(job.salary);

    return List<JobPosition>.generate(job.primaryTitles.length, (index) {
      final title = job.primaryTitles[index];
      return JobPosition(
        id: '${job.id}_$index',
        title: title,
        baseSalary: baseSalary,
        convertedSalary: convertedSalary,
        currency: job.salary.currency,
        requirements: const [],
      );
    });
  }

  static String _buildPreferenceText(GroupJobEntity job) {
    if (job.primaryTitles.isNotEmpty) return job.primaryTitles.first;
    if (job.employer.companyName != null &&
        job.employer.companyName!.isNotEmpty) {
      return 'Role at ${job.employer.companyName}';
    }
    return job.postingTitle;
  }

  static String _buildDescription(
    GroupJobEntity job,
    String? baseSalaryStr,
    String? convertedSalaryStr,
  ) {
    final parts = <String>[
      job.postingTitle,
      if (job.employer.companyName != null &&
          job.employer.companyName!.isNotEmpty)
        'Employer: ${job.employer.companyName}',
      if (job.agency.name != null && job.agency.name!.isNotEmpty)
        'Agency: ${job.agency.name}',
      if (job.city != null && job.city!.isNotEmpty)
        'Location: ${_composeLocation(job)}',
      if (convertedSalaryStr != null) 'Salary: $convertedSalaryStr',
      if (baseSalaryStr != null) 'Base: $baseSalaryStr',
    ];
    return parts.join(' • ');
  }

  static ContractTerms _buildContractTerms() {
    // Backend contract data not present; leave empty so UI falls back to defaults
    return ContractTerms(duration: '', type: '');
  }

  static String _composeLocation(GroupJobEntity job) {
    final city = job.city;
    final country = job.country;
    if (((city ?? '').trim()).isNotEmpty) return '$city, $country';
    return country;
  }

  static String? _formatBaseSalary(SalarySummaryEntity salary) {
    final min = salary.monthlyMin;
    final max = salary.monthlyMax;
    final cur = salary.currency;
    if (min == null && max == null) return null;
    if (min != null && max != null) {
      return '${cur ?? ''} ${_compact(min)} - ${_compact(max)}'.trim();
    }
    final only = (min ?? max)!;
    return '${cur ?? ''} ${_compact(only)}'.trim();
  }

  static String? _formatConvertedSalary(SalarySummaryEntity salary,
      {String preferred = 'NPR'}) {
    if (salary.converted.isEmpty) return null;
    // Prefer a specific currency if available
    ConvertedAmountEntity preferredAmt;
    try {
      preferredAmt = salary.converted.first;
    } catch (e) {
      print('salary.converted: ${salary.converted}');
      return 'Not available112';
    }
    return '${preferredAmt.currency} ${_compact(preferredAmt.amount)}';
  }

  static String _compact(double value) {
    // Simplified compact formatting without intl dependency here.
    if (value >= 1000000000) {
      return '${(value / 1000000000).toStringAsFixed(1)}B';
    } else if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toStringAsFixed(0);
  }
}
