import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/colors/app_colors.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/routes/route_constants.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/data/models/candidate/model.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/data/models/profile/model.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/candidate/providers/providers.dart'
    as cand;

import '../providers/profile_provider.dart';
import '../providers/providers.dart';

class ProfileCardsGroup extends ConsumerWidget {
  const ProfileCardsGroup({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    final data = ref.watch(getAllProfileProvider);
    ref.listen(profileProvider, (p, n) {
      ref.refresh(getAllProfileProvider);
    });
    return data.when(data: (items) {
      // Derive counts from the first profile entity (if available)
      final first = items.isNotEmpty ? items.first : null;
      final skillsCount = first?.profileBlob?.skills?.length ?? 0;
      final educationCount = first?.profileBlob?.education?.length ?? 0;
      final trainingsCount = first?.profileBlob?.trainings?.length ?? 0;
      final experienceCount = first?.profileBlob?.experience?.length ?? 0;

      // Personal Information completion count from Candidate profile
      final candState = ref.watch(cand.getCandidateByIdProvider);
      final candItem = candState.valueOrNull;
      const personalTotal =
          6; // full_name, phone, passport_number, gender, unified address
      int personalCompleted = 0;
      if (candItem != null) {
        // include for email 
        if ((candItem.email ?? '').toString().trim().isNotEmpty)
          personalCompleted++;
        if ((candItem.fullName ?? '').toString().trim().isNotEmpty)
          personalCompleted++;
        if ((candItem.phone ?? '').toString().trim().isNotEmpty)
          personalCompleted++;
        if ((candItem.passportNumber ?? '').toString().trim().isNotEmpty)
          personalCompleted++;
        if ((candItem.gender ?? '').toString().trim().isNotEmpty)
          personalCompleted++;
        // Address treated as a single unified field
        if (candItem.address != null &&
            ((candItem.address!.name ?? '').toString().trim().isNotEmpty ||
                candItem.address!.coordinates != null)) {
          personalCompleted++;
        }
      }

      return Column(
        children: [
         if(false) Text((candItem as CandidateModel).toJson().toString().split(',').join('\n') ?? ""),
          if (false)
            Text(items.map((e) => (e as ProfileModel).toJson()).toString()),
          body(
            context,
            skillsCount: skillsCount,
            educationCount: educationCount,
            trainingsCount: trainingsCount,
            experienceCount: experienceCount,
            personalCompleted: personalCompleted,
            personalTotal: personalTotal,
          ),
        ],
      );
    }, error: (error, st) {
      return GestureDetector(
        onTap: () {
          ref.refresh(getAllProfileProvider);
        },
        child: Text("$error\n$st"),
      );
    }, loading: () {
      return Text("ss");
    });
  }

  Column body(BuildContext context,
      {required int skillsCount,
      required int educationCount,
      required int trainingsCount,
      required int experienceCount,
      required int personalCompleted,
      required int personalTotal}) {
    final progress = personalTotal == 0
        ? 0.0
        : (personalCompleted / personalTotal).clamp(0, 1).toDouble();
    return Column(
      children: [
        _ProfileMenuItem(
          icon: Icons.person,
          title: "Personal Information ($personalCompleted/$personalTotal)",
          subtitle: "Update your personal details",
          iconColor: Colors.blue,
          trailingWidget: SizedBox(
            width: 72,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: Colors.grey[200],
                color: Colors.blue,
              ),
            ),
          ),
          onTap: () {
            Navigator.pushNamed(
              context,
              RouteConstants.kPersonalInfoScreen,
            );
          },
        ),
        _ProfileMenuItem(
          icon: Icons.work,
          title: "Work Experience ($experienceCount)",
          subtitle: "Manage your work history",
          iconColor: Colors.green,
          onTap: () {
            Navigator.pushNamed(
              context,
              RouteConstants.kWorkExperienceScreen,
            );
          },
        ),
        _ProfileMenuItem(
          icon: Icons.school,
          title: "Education ($educationCount)",
          subtitle: "Add your qualifications",
          iconColor: Colors.orange,
          onTap: () {
            Navigator.pushNamed(
              context,
              RouteConstants.kEducationScreen,
            );
          },
        ),
        _ProfileMenuItem(
          icon: Icons.school,
          title: "Training ($trainingsCount)",
          subtitle: "Add your trainings",
          iconColor: Colors.teal,
          onTap: () {
            Navigator.pushNamed(
              context,
              RouteConstants.kTrainingScreen,
            );
          },
        ),
        _ProfileMenuItem(
          icon: Icons.language,
          title: "Languages & Skills ($skillsCount)",
          subtitle: "Showcase your abilities",
          iconColor: Colors.purple,
          onTap: () {
            Navigator.pushNamed(
              context,
              RouteConstants.kSkillsScreen,
            );
          },
        ),
        // _ProfileMenuItem(
        //   icon: Icons.card_membership,
        //   title: "Licenses & Certifications",
        //   subtitle: "Professional credentials",
        //   iconColor: Colors.teal,
        //   onTap: () {},
        // ),
        _ProfileMenuItem(
          icon: Icons.settings,
          title: "Settings",
          subtitle: "Privacy and preferences",
          iconColor: AppColors.textSecondary,
          onTap: () {
            Navigator.pushNamed(context, RouteConstants.kSettingsScreen);
          },
          showDivider: false,
        ),
      ],
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;
  final VoidCallback onTap;
  final bool showDivider;
  final Widget? trailingWidget;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconColor,
    required this.onTap,
    this.showDivider = true,
    this.trailingWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 8,
          ),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          trailing: trailingWidget ??
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey[400],
              ),
          onTap: onTap,
        ),
        if (showDivider)
          Divider(
            height: 1,
            indent: 68,
            endIndent: 20,
            color: Colors.grey[200],
          ),
      ],
    );
  }
}
