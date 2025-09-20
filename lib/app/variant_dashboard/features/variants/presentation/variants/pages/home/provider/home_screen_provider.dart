import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/data/models/jobs/mobile_job_model.dart';
import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/variants/pages/home/home_page_variant1.dart';
import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/variants/pages/home/job_posting.dart';

final jobDashboardDataProvider = ChangeNotifierProvider<HomeScreenProvider>((
  ref,
) {
  return HomeScreenProvider();
});

class HomeScreenProvider extends ChangeNotifier {
  final Candidate _candidate;
  final List<CandidatePreference> _preferences;
  final List<JobProfile> _jobProfiles;
  final List<MobileJobEntity> _recommendedJobs;
  final List<Application> _applications;
  final DashboardAnalytics _analytics;
  JobFilters _currentFilters;

  HomeScreenProvider()
    : _candidate = Candidate(
        id: 'cand_001',
        fullName: 'Ram Kharel',
        phone: '+9779812345678',
        address: {
          'street': 'Thamel, Kathmandu',
          'city': 'Kathmandu',
          'country': 'Nepal',
          'coordinates': {'lat': 27.7172, 'lng': 85.3240},
        },
        skills: ['Electrician', 'Plumber'],
        education: [
          {
            'degree': 'Computer Science',
            'institution': 'Tribhuvan University',
            'year': 2020,
          },
        ],
      ),
      _preferences = [
        CandidatePreference(title: 'Hospitality', priority: 1),
        CandidatePreference(title: 'Construction Worker', priority: 2),
        CandidatePreference(title: 'Electrician', priority: 3),
      ],
      _jobProfiles = [
        JobProfile(
          id: 'prof_001',
          candidateId: 'cand_001',
          profileBlob: {
            'preferred_titles': ['Flutter Developer', 'Mobile Developer'],
            'experience_level': 'Mid-level',
            'remote_preference': true,
          },
          label: 'Tech Profile',
          updatedAt: DateTime.now().subtract(Duration(days: 2)),
        ),
      ],
      _recommendedJobs = [
        MobileJobEntity(
          id: 'post_001',
          postingTitle: 'Hospitality Staff Recruitment - Multiple Roles',
          country: 'Qatar',
          city: 'Doha',
          agency: 'Gulf Hospitality Agency',
          employer: 'Doha Grand Hotel',
          description:
              'Hiring skilled hospitality staff for hotel operations and customer service.',
          contractTerms: ContractTerms(duration: '2 years', type: 'Full-time'),
          postedDate: DateTime.now().subtract(const Duration(days: 2)),
          preferenceText: 'Hospitality',
          positions: [
            JobPosition(
              id: 'pos_001',
              title: 'Waiter',
              baseSalary: 'QAR 1,800',
              convertedSalary: '\$495',
              currency: 'USD',
              requirements: [
                'Basic English',
                'Hospitality experience preferred',
              ],
            ),
            JobPosition(
              id: 'pos_002',
              title: 'Chef Assistant',
              baseSalary: 'QAR 2,200',
              convertedSalary: '\$605',
              currency: 'USD',
              requirements: ['Cooking skills', '1+ year kitchen experience'],
            ),
          ],
        ),
        MobileJobEntity(
          id: 'post_002',
          postingTitle: 'Skilled Labor Recruitment - Construction Projects',
          country: 'UAE',
          city: 'Dubai',
          agency: 'Global Workforce Ltd.',
          employer: 'Dubai Infrastructure Corp.',
          description:
              'Looking for experienced workers for large-scale construction projects.',
          contractTerms: ContractTerms(duration: '3 years', type: 'Contract'),
          postedDate: DateTime.now().subtract(const Duration(days: 1)),
          preferenceText: 'Construction Worker',

          positions: [
            JobPosition(
              id: 'pos_003',
              title: 'Construction Worker',
              baseSalary: 'AED 1,600',
              convertedSalary: '\$435',
              currency: 'USD',
              requirements: ['Physical fitness', 'Site safety awareness'],
            ),
            // JobPosition(
            //   id: 'pos_004',
            //   title: 'Electrician',
            //   baseSalary: 'AED 2,200',
            //   convertedSalary: '\$600',
            //   currency: 'USD',
            //   requirements: [
            //     'Wiring experience',
            //     'Electric safety training',
            //     '2+ years experience',
            //   ],
            // ),
          ],
        ),
      ],
      _applications = [
        Application(
          id: 'app_001',
          candidateId: 'cand_001',
          postingId: 'post_001',
          posting: MobileJobEntity(
            id: 'post_003',
            postingTitle: 'Hospitality Staff Recruitment - Multiple Roles',
            country: 'Qatar',
            city: 'Doha',
            agency: 'Gulf Hospitality Agency',
            employer: 'Doha Grand Hotel',
            description:
                'Hiring skilled hospitality staff for hotel operations and customer service.',
            contractTerms: ContractTerms(duration: '1 year', type: 'Full-time'),
            postedDate: DateTime.now().subtract(Duration(days: 7)),
            preferenceText: 'Electrician',

            positions: [],
          ),
          status: ApplicationStatus.interviewScheduled,
          appliedAt: DateTime.now().subtract(Duration(days: 5)),
          interviewDetail: InterviewDetail(
            id: 'int_001',
            scheduledAt: DateTime.now().add(Duration(days: 3)),
            location: 'Lakeside, Pokhara',
            contact: 'HR Team - +977-61-123456',
            notes: 'Interview with the founding team',
          ),
          history: [
            ApplicationHistory(
              id: 'hist_001',
              status: ApplicationStatus.applied,
              timestamp: DateTime.now().subtract(Duration(days: 5)),
            ),
            ApplicationHistory(
              id: 'hist_002',
              status: ApplicationStatus.underReview,
              timestamp: DateTime.now().subtract(Duration(days: 3)),
            ),
            ApplicationHistory(
              id: 'hist_003',
              status: ApplicationStatus.interviewScheduled,
              timestamp: DateTime.now().subtract(Duration(days: 1)),
            ),
          ],
        ),
      ],
      _analytics = DashboardAnalytics(
        recommendedJobsCount: 15,
        topMatchedTitles: [
          'Flutter Developer',
          'Mobile Developer',
          'Frontend Developer',
        ],
        countriesDistribution: {
          'Nepal': 8,
          'Qatar': 4,
          'UAE': 2,
          'Malaysia': 1,
        },
        recentlyAppliedCount: 3,
        totalApplications: 12,
        interviewsScheduled: 2,
      ),
      _currentFilters = JobFilters();

  // Getters
  Candidate get candidate => _candidate;
  List<CandidatePreference> get preferences => _preferences;
  List<JobProfile> get jobProfiles => _jobProfiles;
  List<MobileJobEntity> get recommendedJobs => _recommendedJobs;
  List<Application> get applications => _applications;
  DashboardAnalytics get analytics => _analytics;
  JobFilters get currentFilters => _currentFilters;

  // Business Logic Methods
  void addPreference(String title) {
    // Remove if exists and add to top
    _preferences.removeWhere((p) => p.title == title);
    _preferences.insert(0, CandidatePreference(title: title, priority: 1));
    _reindexPreferences();
    notifyListeners();
  }

  void removePreference(String title) {
    _preferences.removeWhere((p) => p.title == title);
    _reindexPreferences();
    notifyListeners();
  }

  void _reindexPreferences() {
    for (int i = 0; i < _preferences.length; i++) {
      _preferences[i] = CandidatePreference(
        title: _preferences[i].title,
        priority: i + 1,
      );
    }
  }

  void updateFilters(JobFilters filters) {
    _currentFilters = filters;
    notifyListeners();
  }

  List<Application> getApplicationsByStatus(ApplicationStatus? status) {
    if (status == null) return _applications;
    return _applications.where((app) => app.status == status).toList();
  }

  List<Application> getUpcomingInterviews() {
    return _applications
        .where(
          (app) =>
              app.status == ApplicationStatus.interviewScheduled &&
              app.interviewDetail != null &&
              app.interviewDetail!.scheduledAt.isAfter(DateTime.now()),
        )
        .toList();
  }
}
