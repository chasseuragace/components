import 'package:flutter/material.dart';

class UserSettingsVariant1 extends StatefulWidget {
  const UserSettingsVariant1({super.key});

  @override
  State<UserSettingsVariant1> createState() => _UserSettingsVariant1State();
}

class _UserSettingsVariant1State extends State<UserSettingsVariant1> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings V1'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          Text(
            'General Settings',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SwitchListTile(
            title: const Text('Enable Notifications'),
            value: _notificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
            secondary: const Icon(Icons.notifications),
          ),
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: _darkModeEnabled,
            onChanged: (bool value) {
              setState(() {
                _darkModeEnabled = value;
              });
            },
            secondary: const Icon(Icons.brightness_2),
          ),
          const Divider(),
          ListTile(
            title: const Text('About App'),
            leading: const Icon(Icons.info_outline),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
