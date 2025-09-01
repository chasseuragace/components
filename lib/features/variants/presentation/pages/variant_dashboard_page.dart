import 'package:flutter/material.dart';
import 'package:variant_dashboard/features/variants/presentation/variants/pages/home/home_page_variant_5.dart';
import 'package:variant_dashboard/features/variants/presentation/variants/pages/job_details/job_details_screen.dart';
import 'package:variant_dashboard/features/variants/presentation/variants/pages/job_details/job_details_screen2.dart';
import 'package:variant_dashboard/features/variants/presentation/variants/pages/job_details/job_details_screen3.dart';
import 'package:variant_dashboard/home_page_variant_4/presentation/home_page_variant4.dart';

import '../../domain/entities/variant_group.dart';
import '../../domain/entities/variant_item.dart';
import '../variants/pages/home/home_page_variant1.dart';
import '../variants/pages/home/home_page_variant2.dart';
import '../variants/pages/home/home_page_variant3.dart';
import '../variants/pages/settings/user_settings_variant1.dart';
import '../variants/pages/settings/user_settings_variant2.dart';
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

class VariantDashboardPage extends StatelessWidget {
  VariantDashboardPage({super.key});

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
          name: 'Home V3 - Grid View',
          builder: (BuildContext context) => const HomePageVariant3(),
        ),
        VariantItem(
          name: 'Home V4 - View',
          builder: (BuildContext context) => const HomePageVariant4(),
        ),
        VariantItem(
          name: 'Home V5 - View',
          builder: (BuildContext context) => const HomePageVariant5(),
        ),
      ],
    ),
    VariantGroup(
      title: 'Job Details Variants',
      variants: <VariantItem>[
        VariantItem(
          name: 'Job Details V1',
          builder: (BuildContext context) => JobDetailScreen(job: job),
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
      title: 'User Settings Variants',
      variants: <VariantItem>[
        VariantItem(
          name: 'Settings V1 - Switches',
          builder: (BuildContext context) => const UserSettingsVariant1(),
        ),
        VariantItem(
          name: 'Settings V2 - Form Inputs',
          builder: (BuildContext context) => const UserSettingsVariant2(),
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UI Variants Dashboard'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView.builder(
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
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                Wrap(
                  spacing: 24.0,
                  runSpacing: 24.0,
                  alignment: WrapAlignment.center,
                  children: group.variants
                      .map<Widget>(
                        (VariantItem variant) =>
                            VariantPreview(variant: variant),
                      )
                      .toList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
