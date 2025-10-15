import 'package:flutter/material.dart';
import 'widgets/settings_section.dart';
import 'widgets/settings_item.dart';
import 'widgets/notification_toggle.dart';
import 'widgets/language_option.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          "Settings",
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),

            // Account Settings Section
            SettingsSection(
              title: "Account",
              items: [
                SettingsItem(
                  icon: Icons.notifications_outlined,
                  title: "Notification Preferences",
                  subtitle: "Manage your notifications",
                  onTap: () => _showNotificationSettings(context),
                ),
                SettingsItem(
                  icon: Icons.language_outlined,
                  title: "Language",
                  subtitle: "English",
                  onTap: () => _showLanguageSettings(context),
                ),
                SettingsItem(
                  icon: Icons.security_outlined,
                  title: "Privacy & Security",
                  subtitle: "Manage your privacy settings",
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Support Section
            SettingsSection(
              title: "Support",
              items: [
                SettingsItem(
                  icon: Icons.help_outline,
                  title: "Help Center",
                  subtitle: "Get help and support",
                  onTap: () {},
                ),
                SettingsItem(
                  icon: Icons.feedback_outlined,
                  title: "Send Feedback",
                  subtitle: "Help us improve the app",
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Danger Zone
            SettingsSection(
              title: "Account Management",
              items: [
                SettingsItem(
                  icon: Icons.person_off_outlined,
                  title: "Deactivate Account",
                  subtitle: "Temporarily disable your account",
                  onTap: () => _showDeactivateDialog(context),
                  isDanger: true,
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Logout Button
            // Container(
            //   margin: const EdgeInsets.symmetric(horizontal: 24),
            //   width: double.infinity,
            //   child: ElevatedButton(
            //     onPressed: () => _showLogoutDialog(context),
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: Colors.red[50],
            //       foregroundColor: Colors.red,
            //       elevation: 0,
            //       padding: const EdgeInsets.symmetric(vertical: 16),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(12),
            //       ),
            //     ),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Icon(Icons.logout, color: Colors.red[600]),
            //         const SizedBox(width: 8),
            //         Text(
            //           "Log out",
            //           style: TextStyle(
            //             fontSize: 16,
            //             fontWeight: FontWeight.w600,
            //             color: Colors.red[600],
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),

            // const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void _showNotificationSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    "Notification Preferences",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  NotificationToggle("Job Alerts", true),
                  NotificationToggle("Interview Reminders", true),
                  NotificationToggle("Application Updates", false),
                  NotificationToggle("Marketing Emails", false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 300,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              child: const Text(
                "Select Language",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  LanguageOption("English", true),
                  LanguageOption("Nepali", false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeactivateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Deactivate Account"),
        content: const Text(
          "Are you sure you want to deactivate your account? This action can be reversed later.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle deactivation
            },
            child: const Text(
              "Deactivate",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Log Out"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              // Handle logout
            },
            child: const Text("Log Out", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
