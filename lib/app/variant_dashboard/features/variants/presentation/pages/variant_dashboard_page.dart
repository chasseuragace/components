import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/onboarding/page/onboarding_screen_1.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/preferences/page/set_preferences_screen.dart';
import 'package:variant_dashboard/app/variant_dashboard/features/variants/domain/entities/manpower_agency.dart';
import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/variants/pages/agency_detail/agency_detail_screen_1.dart';
import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/variants/pages/agency_detail/agency_detail_screen_2.dart';
import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/variants/pages/agency_detail/agency_detail_screen_3.dart';
import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/variants/pages/agency_listings/agency_listing_screen_1.dart';
import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/variants/pages/agency_listings/agency_listing_screen_2.dart';
import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/variants/pages/agency_listings/agency_listing_screen_3.dart';
import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/variants/pages/home/home_page_variant_5.dart';
import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/variants/pages/interview_schedule/interview_schedule_screen1.dart';
import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/variants/pages/interview_schedule/interview_schedule_screen2.dart';
import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/variants/pages/interview_schedule/interview_schedule_screen3.dart';
import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/variants/pages/job_details/job_details_screen.dart';
import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/variants/pages/job_details/job_details_screen2.dart';
import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/variants/pages/job_details/job_details_screen3.dart';
import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/variants/pages/job_listings/job_listings_1.dart';
import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/variants/pages/job_listings/job_listings_2.dart';
import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/variants/pages/profile/profile_screen_1.dart';
import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/variants/pages/profile/profile_screen_2.dart';
import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/variants/pages/profile/profile_screen_3.dart';
import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/variants/pages/set_preferences/set_preferences_1.dart';
import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/variants/pages/set_preferences/set_preferences_2.dart';
import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/variants/pages/settings/user_settings_1.dart';
import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/variants/pages/settings/user_settings_2.dart';
import 'package:variant_dashboard/app/variant_dashboard/home_page_variant_4/presentation/home_page_variant4.dart';

import '../../domain/entities/variant_group.dart';
import '../../domain/entities/variant_item.dart';
import '../variants/pages/home/home_page_variant1.dart';
import '../variants/pages/home/home_page_variant2.dart';
import '../widgets/variant_preview.dart';

const job = {
  'title': 'Senior Flutter Developer',
  'company': 'TechCorp Nepal',
  'location': 'Kathmandu, Nepal',
  'salary': 'NPR 80,000 - 120,000',
  'type': 'Full Time',
  'experience': '3-5 years',
  'posted': '2 days ago',
  'isRemote': true,
  'isFeatured': true,
  'companyLogo': 'T',
  'matchPercentage': 95,
};

JobPosting blueCollarJobQatar = JobPosting(
  id: 'post_2001',
  postingTitle: 'Hospitality & Maintenance Staff - Multiple Openings',
  country: 'Qatar',
  city: 'Doha',
  agency: 'Gulf Manpower Agency',
  employer: 'Qatar Hospitality Services',
  positions: [
    JobPosition(
      id: 'pos_2001',
      title: 'Waiter',
      baseSalary: 'QAR 1,500',
      convertedSalary: '\$410',
      currency: 'USD',
      requirements: [
        'Good communication skills',
        'Experience in restaurant/hotel service',
      ],
    ),
    JobPosition(
      id: 'pos_2002',
      title: 'Cleaner',
      baseSalary: 'QAR 1,200',
      convertedSalary: '\$330',
      currency: 'USD',
      requirements: ['Basic cleaning skills', 'Hardworking and punctual'],
    ),
    JobPosition(
      id: 'pos_2003',
      title: 'Driver',
      baseSalary: 'QAR 1,800',
      convertedSalary: '\$490',
      currency: 'USD',
      requirements: [
        'Valid GCC driving license',
        '2+ years driving experience',
      ],
    ),
  ],
  description:
      'We are hiring hospitality and maintenance staff for hotels and service apartments in Doha. Openings available for waiters, cleaners, and drivers. Food, accommodation, and transportation are provided by the company.',
  contractTerms: {'duration': '2 years', 'type': 'Full-time'},
  isActive: true,
  postedDate: DateTime.now().subtract(Duration(days: 1)),
  preferencePriority: '1',
  preferenceText: 'Immediate Joining',
  location: 'Doha, Qatar',
  experience: '1-2 years',
  salary: 'QAR 1,200 - 1,800 + benefits',
  type: 'Full Time',
  isRemote: false,
  isFeatured: true,
  companyLogo: 'QH',
  matchPercentage: '90',
);

final scaleprovider = StateProvider<double>((ref) => 1.0);

// class VariantDashboardPage extends StatelessWidget {
//   VariantDashboardPage({super.key});

//   final List<VariantGroup> _variantGroups = <VariantGroup>[
//     VariantGroup(
//       title: 'Home Page Variants',
//       variants: <VariantItem>[
//         VariantItem(
//           name: 'Home V1 - Bassic',
//           builder: (BuildContext context) => const HomePageVariant1(),
//         ),
//         VariantItem(
//           name: 'Home V2 - List View',
//           builder: (BuildContext context) => const HomePageVariant2(),
//         ),

//         VariantItem(
//           name: 'Home V3 - View',
//           builder: (BuildContext context) => const HomePageVariant4(),
//         ),
//         VariantItem(
//           name: 'Home V4 - View',
//           builder: (BuildContext context) => const HomePageVariant5(),
//         ),
//       ],
//     ),
//     VariantGroup(
//       title: 'Job Details Variants',
//       variants: <VariantItem>[
//         VariantItem(
//           name: 'Job Details V1',
//           builder: (BuildContext context) =>
//               JobDetailScreen(job: blueCollarJobQatar),
//         ),
//         VariantItem(
//           name: 'Job Details V2',
//           builder: (BuildContext context) => const JobDetailScreen2(job: job),
//         ),
//         VariantItem(
//           name: 'Job Details V2',
//           builder: (BuildContext context) => const JobDetailScreen3(job: job),
//         ),
//       ],
//     ),
//     VariantGroup(
//       title: 'Interview Schedule Variants',
//       variants: <VariantItem>[
//         VariantItem(
//           name: 'Interview Schedule V1',
//           builder: (BuildContext context) => const InterviewScheduleScreen1(),
//         ),
//         VariantItem(
//           name: 'Interview Schedule V1',
//           builder: (BuildContext context) => const InterviewScheduleScreen2(),
//         ),
//         VariantItem(
//           name: 'Interview Schedule V1',
//           builder: (BuildContext context) => const InterviewScheduleScreen3(),
//         ),
//       ],
//     ),
//     VariantGroup(
//       title: 'Agency Detail Variants',
//       variants: <VariantItem>[
//         VariantItem(
//           name: 'Agency Detail V1 ',
//           builder: (BuildContext context) =>
//               AgencyDetailScreen1(agency: sampleAgencies.first),
//         ),
//         VariantItem(
//           name: 'Agency Detail V2 ',
//           builder: (BuildContext context) =>
//               AgencyDetailScreen2(agency: sampleAgencies.first),
//         ),
//         VariantItem(
//           name: 'Agency Detail V3 ',
//           builder: (BuildContext context) =>
//               AgencyDetailScreen3(agency: sampleAgencies.first),
//         ),
//       ],
//     ),
//     VariantGroup(
//       title: 'Onboarding Variants',
//       variants: <VariantItem>[
//         VariantItem(
//           name: 'Onboarding V1',
//           builder: (BuildContext context) => const OnboardingScreen1(),
//         ),
//       ],
//     ),
//     VariantGroup(
//       title: 'Agency Listing Variants',
//       variants: <VariantItem>[
//         VariantItem(
//           name: 'Agency Listing V1',
//           builder: (BuildContext context) => const AgencyListingScreen1(),
//         ),
//         VariantItem(
//           name: 'Agency Listing V2',
//           builder: (BuildContext context) => const AgencyListingScreen2(),
//         ),
//         VariantItem(
//           name: 'Agency Listing V3',
//           builder: (BuildContext context) => const AgencyListingScreen3(),
//         ),
//       ],
//     ),
//     VariantGroup(
//       title: 'Agency Listing Variants',
//       variants: <VariantItem>[
//         VariantItem(
//           name: 'Agency Listing V1',
//           builder: (BuildContext context) => const AgencyListingScreen1(),
//         ),
//         VariantItem(
//           name: 'Agency Listing V2',
//           builder: (BuildContext context) => const AgencyListingScreen2(),
//         ),
//         VariantItem(
//           name: 'Agency Listing V3',
//           builder: (BuildContext context) => const AgencyListingScreen3(),
//         ),
//       ],
//     ),

//     VariantGroup(
//       title: 'Job Listings Variants',
//       variants: <VariantItem>[
//         VariantItem(
//           name: 'Job Listings V1',
//           builder: (BuildContext context) => JobListings1(),
//         ),
//         VariantItem(
//           name: 'Job Listings V2',
//           builder: (BuildContext context) => const JobListings2(),
//         ),
//       ],
//     ),
//     VariantGroup(
//       title: 'Set Preference Variants',
//       variants: <VariantItem>[
//         VariantItem(
//           name: 'Preferences V1',
//           builder: (BuildContext context) => const SetPreferences1(),
//         ),
//         VariantItem(
//           name: 'Preferences V2',
//           builder: (BuildContext context) => const SetPreferences2(),
//         ),
//         VariantItem(
//           name: 'Preferences V3',
//           builder: (BuildContext context) => const SetPreferences3(),
//         ),
//       ],
//     ),
//     VariantGroup(
//       title: 'Profile Variants',
//       variants: <VariantItem>[
//         VariantItem(
//           name: 'Profile V1',
//           builder: (BuildContext context) => const ProfileScreen1(),
//         ),
//         VariantItem(
//           name: 'Profile V2',
//           builder: (BuildContext context) => const ProfileScreen2(),
//         ),
//         VariantItem(
//           name: 'Profile V3',
//           builder: (BuildContext context) => const ProfileScreen3(),
//         ),
//       ],
//     ),
//     VariantGroup(
//       title: 'User Settings Variants',
//       variants: <VariantItem>[
//         VariantItem(
//           name: 'Settings V1',
//           builder: (BuildContext context) => const SettingsScreen1(),
//         ),
//         VariantItem(
//           name: 'Settings V2',
//           builder: (BuildContext context) => const SettingsScreen2(),
//         ),
//       ],
//     ),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Consumer(
//       builder: (context, ref, child) {
//         final scale = ref.watch(scaleprovider);
//         return Scaffold(
//           appBar: AppBar(
//             actions: [
//               Slider(
//                 value: scale,
//                 min: 1,
//                 max: 10,
//                 divisions: 10,
//                 label: '1',
//                 onChanged: (double value) {
//                   ref.read(scaleprovider.notifier).state = value;
//                 },
//               ),
//             ],
//             title: const Text('UI Variants Dashboard'),
//             centerTitle: true,
//             backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//           ),
//           body: Transform.scale(
//             scale: ref.watch(scaleprovider),
//             child: ListView.builder(
//               padding: const EdgeInsets.symmetric(vertical: 20.0),
//               itemCount: _variantGroups.length,
//               itemBuilder: (BuildContext context, int groupIndex) {
//                 final VariantGroup group = _variantGroups[groupIndex];
//                 return Padding(
//                   padding: const EdgeInsets.only(bottom: 24.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       Padding(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 16.0,
//                           vertical: 8.0,
//                         ),
//                         child: Text(
//                           group.title,
//                           style: Theme.of(context).textTheme.headlineMedium,
//                         ),
//                       ),
//                       Wrap(
//                         spacing: 24.0,
//                         runSpacing: 24.0,
//                         alignment: WrapAlignment.center,
//                         children: group.variants
//                             .map<Widget>(
//                               (VariantItem variant) =>
//                                   VariantPreview(variant: variant),
//                             )
//                             .toList(),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

class VariantDashboardPage extends StatefulWidget {
  const VariantDashboardPage({super.key});

  @override
  State<VariantDashboardPage> createState() => _VariantDashboardPageState();
}

class _VariantDashboardPageState extends State<VariantDashboardPage> {
  VariantItem? selectedVariant;
  final List<VariantGroup> _variantGroups = <VariantGroup>[
    VariantGroup(
      title: 'Home Page Variants',
      variants: <VariantItem>[
        VariantItem(
          name: 'Home V1 - Bassic',
          builder: (BuildContext context) => const HomePageVariant1(),
        ),
        VariantItem(
          name: 'Home V2 - List View',
          builder: (BuildContext context) => const HomePageVariant2(),
        ),
        VariantItem(
          name: 'Home V3 - View',
          builder: (BuildContext context) => const HomePageVariant4(),
        ),
        VariantItem(
          name: 'Home V4 - View',
          builder: (BuildContext context) => const HomePageVariant5(),
        ),
      ],
    ),
    VariantGroup(
      title: 'Job Details Variants',
      variants: <VariantItem>[
        VariantItem(
          name: 'Job Details V1',
          builder: (BuildContext context) =>
              JobDetailScreen(job: blueCollarJobQatar),
        ),
        VariantItem(
          name: 'Job Details V2',
          builder: (BuildContext context) => const JobDetailScreen2(job: job),
        ),
        VariantItem(
          name: 'Job Details V2',
          builder: (BuildContext context) => const JobDetailScreen3(job: job),
        ),
      ],
    ),
    VariantGroup(
      title: 'Interview Schedule Variants',
      variants: <VariantItem>[
        VariantItem(
          name: 'Interview Schedule V1',
          builder: (BuildContext context) => const InterviewScheduleScreen1(),
        ),
        VariantItem(
          name: 'Interview Schedule V1',
          builder: (BuildContext context) => const InterviewScheduleScreen2(),
        ),
        VariantItem(
          name: 'Interview Schedule V1',
          builder: (BuildContext context) => const InterviewScheduleScreen3(),
        ),
      ],
    ),
    VariantGroup(
      title: 'Agency Detail Variants',
      variants: <VariantItem>[
        VariantItem(
          name: 'Agency Detail V1 ',
          builder: (BuildContext context) =>
              AgencyDetailScreen1(agency: sampleAgencies.first),
        ),
        VariantItem(
          name: 'Agency Detail V2 ',
          builder: (BuildContext context) =>
              AgencyDetailScreen2(agency: sampleAgencies.first),
        ),
        VariantItem(
          name: 'Agency Detail V3 ',
          builder: (BuildContext context) =>
              AgencyDetailScreen3(agency: sampleAgencies.first),
        ),
      ],
    ),
    VariantGroup(
      title: 'Onboarding Variants',
      variants: <VariantItem>[
        VariantItem(
          name: 'Onboarding V1',
          builder: (BuildContext context) => const OnboardingScreen1(),
        ),
      ],
    ),
    VariantGroup(
      title: 'Agency Listing Variants',
      variants: <VariantItem>[
        VariantItem(
          name: 'Agency Listing V1',
          builder: (BuildContext context) => const AgencyListingScreen1(),
        ),
        VariantItem(
          name: 'Agency Listing V2',
          builder: (BuildContext context) => const AgencyListingScreen2(),
        ),
        VariantItem(
          name: 'Agency Listing V3',
          builder: (BuildContext context) => const AgencyListingScreen3(),
        ),
      ],
    ),
    VariantGroup(
      title: 'Agency Listing Variants',
      variants: <VariantItem>[
        VariantItem(
          name: 'Agency Listing V1',
          builder: (BuildContext context) => const AgencyListingScreen1(),
        ),
        VariantItem(
          name: 'Agency Listing V2',
          builder: (BuildContext context) => const AgencyListingScreen2(),
        ),
        VariantItem(
          name: 'Agency Listing V3',
          builder: (BuildContext context) => const AgencyListingScreen3(),
        ),
      ],
    ),
    VariantGroup(
      title: 'Job Listings Variants',
      variants: <VariantItem>[
        VariantItem(
          name: 'Job Listings V1',
          builder: (BuildContext context) => JobListings1(),
        ),
        VariantItem(
          name: 'Job Listings V2',
          builder: (BuildContext context) => const JobListings2(),
        ),
      ],
    ),
    VariantGroup(
      title: 'Set Preference Variants',
      variants: <VariantItem>[
        VariantItem(
          name: 'Preferences V1',
          builder: (BuildContext context) => const SetPreferences1(),
        ),
        VariantItem(
          name: 'Preferences V2',
          builder: (BuildContext context) => const SetPreferences2(),
        ),
        VariantItem(
          name: 'Preferences V3',
          builder: (BuildContext context) => const SetPreferenceScreen(),
        ),
      ],
    ),
    VariantGroup(
      title: 'Profile Variants',
      variants: <VariantItem>[
        VariantItem(
          name: 'Profile V1',
          builder: (BuildContext context) => const ProfileScreen1(),
        ),
        VariantItem(
          name: 'Profile V2',
          builder: (BuildContext context) => const ProfileScreen2(),
        ),
        VariantItem(
          name: 'Profile V3',
          builder: (BuildContext context) => const ProfileScreen3(),
        ),
      ],
    ),
    VariantGroup(
      title: 'User Settings Variants',
      variants: <VariantItem>[
        VariantItem(
          name: 'Settings V1',
          builder: (BuildContext context) => const SettingsScreen1(),
        ),
        VariantItem(
          name: 'Settings V2',
          builder: (BuildContext context) => const SettingsScreen2(),
        ),
      ],
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final scale = ref.watch(scaleprovider);

        return Scaffold(
          appBar: AppBar(
            actions: [
              Slider(
                value: scale,
                min: 1,
                max: 10,
                divisions: 10,
                label: scale.toStringAsFixed(1),
                onChanged: (double value) {
                  ref.read(scaleprovider.notifier).state = value;
                },
              ),
            ],
            title: const Text('UI Variants Dashboard'),
            centerTitle: true,
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          ),
          body: Row(
            children: [
              // LEFT SIDE → list of previews
              Expanded(
                flex: 3,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  itemCount: _variantGroups.length,
                  itemBuilder: (BuildContext context, int groupIndex) {
                    final VariantGroup group = _variantGroups[groupIndex];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            child: Text(
                              group.title,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          Wrap(
                            spacing: 24.0,
                            runSpacing: 24.0,
                            alignment: WrapAlignment.start,
                            children: group.variants.map<Widget>((variant) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() => selectedVariant = variant);
                                },
                                child: Hero(
                                  tag: variant.name,
                                  child: Transform.scale(
                                    scale: 0.8,
                                    child: VariantPreview(variant: variant),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // RIGHT SIDE → zoomed detail preview
              Expanded(
                flex: 1,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: selectedVariant != null
                      ? Hero(
                          tag: selectedVariant!.name,
                          child: Center(
                            child: Transform.scale(
                              scale: scale, // use slider scale here
                              child: VariantPreview(
                                variant: selectedVariant!,
                                multiplier: .32,
                                isExpanded: true,
                              ),
                            ),
                          ),
                        )
                      : const Center(
                          child: Text(
                            "Select a variant from the left panel",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
