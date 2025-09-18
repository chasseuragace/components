import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/data/models/profile/model.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/profile/page/pages.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/profile/page/profile_screen.dart';
import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/variants/pages/settings/user_settings_1.dart';

import '../providers/providers.dart';

class ProfileCardsGroup extends ConsumerWidget {
  const ProfileCardsGroup({
    super.key,
  });

  @override
  Widget build(BuildContext context,ref) {
    final data = ref.watch(getAllProfileProvider);
    return data.when(data: (data){
      return   Column(
        children: [
          Text(data.map((e)=>(e as ProfileModel).toJson() ).toString()),
          body(context),
        ],
      );
    }, error: (error,st){
      return GestureDetector(
        onTap: (){
          ref.refresh(getAllProfileProvider);
        },
        child: Text("$error\n$st"));
    }, loading: (){
      return Text("ss");
    });
   ;
  }

  Column body(BuildContext context) {
    return Column(
    children: [
      _ProfileMenuItem(
        icon: Icons.person,
        title: "Personal Information",
        subtitle: "Update your personal details",
        iconColor: Colors.blue,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PersonalInfoFormPage(),
            ),
          );
        },
      ),
      _ProfileMenuItem(
        icon: Icons.work,
        title: "Work Experience",
        subtitle: "Manage your work history",
        iconColor: Colors.green,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const WorkExperienceFormPage(),
            ),
          );
        },
      ),
      _ProfileMenuItem(
        icon: Icons.school,
        title: "Education",
        subtitle: "Add your qualifications",
        iconColor: Colors.orange,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EducationFormPage(),
            ),
          );
        },
      ),
      _ProfileMenuItem(
        icon: Icons.school,
        title: "Training",
        subtitle: "Add your trainings",
        iconColor: Colors.teal,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TrainingsFormPage(),
            ),
          );
        },
      ),
      _ProfileMenuItem(
        icon: Icons.language,
        title: "Languages & Skills",
        subtitle: "Showcase your abilities",
        iconColor: Colors.purple,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SkillsFormPage(),
            ),
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
        iconColor: Colors.grey,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SettingsScreen1(),
            ),
          );
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

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconColor,
    required this.onTap,
    this.showDivider = true,
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
          trailing: Icon(
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
