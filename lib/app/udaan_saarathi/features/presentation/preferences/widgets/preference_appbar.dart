import 'package:flutter/material.dart';

class PreferencesAppBar extends StatelessWidget implements PreferredSizeWidget {
  // final VoidCallback onBack;
  final VoidCallback onSkip;

  const PreferencesAppBar({
    super.key,
    // required this.onBack,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      title: const Text(
        'Set Your Job Preferences',
        style: TextStyle(
          color: Color(0xFF1E293B),
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      // leading: IconButton(
      //   icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF64748B)),
      //   onPressed: onBack,
      // ),
      actions: [
        TextButton(
          onPressed: onSkip,
          child: const Text(
            'Skip',
            style: TextStyle(color: Color(0xFF64748B), fontSize: 16),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
