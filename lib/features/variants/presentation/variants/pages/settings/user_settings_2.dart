import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationProvider = StateProvider<bool>((ref) => true);
final languageProvider = StateProvider<String>((ref) => 'English');

// void main(){runApp(ProviderScope(child:SettingsScreen()));}
class SettingsScreen2 extends ConsumerWidget {
  const SettingsScreen2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isNotificationEnabled = ref.watch(notificationProvider);
    final selectedLanguage = ref.watch(languageProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.blue.shade600,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Section
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 3,
            child: ListTile(
              leading: CircleAvatar(
                radius: 28,
                backgroundColor: Colors.blue.shade100,
                child: const Icon(Icons.person, size: 30, color: Colors.white),
              ),
              title: const Text(
                "John Doe",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text("johndoe@email.com"),
              trailing: IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () {},
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Notifications Section
          _buildSectionTitle("Notifications"),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: SwitchListTile(
              value: isNotificationEnabled,
              onChanged: (value) {
                ref.read(notificationProvider.notifier).state = value;
              },
              title: const Text("Enable Notifications"),
              subtitle: const Text(
                "Receive updates about jobs and applications",
              ),
              activeColor: Colors.blue.shade600,
            ),
          ),
          const SizedBox(height: 20),

          // Language Section
          _buildSectionTitle("Language"),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              title: const Text("App Language"),
              subtitle: Text(selectedLanguage),
              trailing: DropdownButton<String>(
                value: selectedLanguage,
                underline: const SizedBox(),
                items: ["English", "Nepali", "Hindi"].map((lang) {
                  return DropdownMenuItem(value: lang, child: Text(lang));
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    ref.read(languageProvider.notifier).state = value;
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Account Section
          _buildSectionTitle("Account"),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.lock_outline, color: Colors.blue),
                  title: const Text("Account Deactivation"),
                  subtitle: const Text("Feature coming soon"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // Future feature
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text(
                    "Logout",
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    // Implement logout
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }
}
