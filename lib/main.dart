import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/features/variants/presentation/variants/pages/home/home_page_variant1.dart';

import 'app.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

/// Data model for a single UI variant.
///
/// Contains a [name] for display and a [builder] function that returns the root
/// widget for this variant. The [builder] should typically return a [Scaffold]
/// or another widget suitable as the `home` for a [MaterialApp].
class VariantItem {
  final String name;
  final Widget Function(BuildContext context) builder;

  VariantItem({required this.name, required this.builder});
}

/// Data model for a group of related UI variants.
///
/// Contains a [title] for the group and a list of [variants].
class VariantGroup {
  final String title;
  final List<VariantItem> variants;

  VariantGroup({required this.title, required this.variants});
}

/// A simple variant for a home page.
// class HomePageVariant1 extends StatelessWidget {
//   const HomePageVariant1({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Home Page V1'),
//         backgroundColor: Theme.of(context).colorScheme.primaryContainer,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'Welcome to Variant 1!',
//               style: Theme.of(context).textTheme.headlineSmall,
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {},
//               child: const Text('Get Started'),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {},
//         child: const Icon(Icons.info),
//       ),
//     );
//   }
// }

/// Another variant for a home page, featuring a list.
class HomePageVariant2 extends StatelessWidget {
  const HomePageVariant2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page V2'),
        backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: Icon(
                Icons.list_alt,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text('List Item ${index + 1}'),
              subtitle: Text('Details for item ${index + 1}'),
              onTap: () {},
            ),
          );
        },
      ),
    );
  }
}

/// A third home page variant with a grid layout.
class HomePageVariant3 extends StatelessWidget {
  const HomePageVariant3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page V3'),
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.2,
        ),
        itemCount: 6,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            elevation: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.dashboard_customize,
                  size: 40,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                const SizedBox(height: 8),
                Text(
                  'Grid ${index + 1}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// A user settings variant with switch controls.
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

/// A user settings variant with form inputs.
class UserSettingsVariant2 extends StatelessWidget {
  const UserSettingsVariant2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings V2'),
        backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Account Information',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.save),
                label: const Text('Save Changes'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Displays a single UI variant in a constrained "mobile-like" view.
///
/// Each variant is rendered within its own [MaterialApp] to simulate an
/// independent application context, allowing it to have its own theme, navigator, etc.
class VariantPreview extends StatelessWidget {
  final VariantItem variant;

  const VariantPreview({super.key, required this.variant});

  // Define typical mobile screen dimensions for the preview.
  static const double _mobileWidth = 320.0;
  static const double _mobileHeight = 568.0; // iPhone 5/SE dimensions

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              variant.name,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 12.0),
            width: _mobileWidth,
            height: _mobileHeight,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: FittedBox(
                fit: BoxFit
                    .contain, // Ensures the entire app fits within the box
                child: SizedBox(
                  width: _mobileWidth,
                  height: _mobileHeight,
                  // Each variant is wrapped in its own MaterialApp
                  child: MaterialApp(
                    debugShowCheckedModeBanner: false,
                    theme: ThemeData(
                      useMaterial3: true,
                      colorSchemeSeed:
                          Colors.blueGrey, // Consistent seed for nested apps
                      appBarTheme: const AppBarTheme(centerTitle: true),
                    ),
                    home: Builder(
                      // Builder is crucial to provide a context that is a descendant of this MaterialApp
                      builder: (BuildContext innerContext) =>
                          variant.builder(innerContext),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The main dashboard page that displays all variant groups and their previews.
class VariantDashboardPage extends StatelessWidget {
  VariantDashboardPage({super.key});

  /// The list of variant groups to be displayed on the dashboard.
  final List<VariantGroup> _variantGroups = <VariantGroup>[
    VariantGroup(
      title: 'Home Page Variants',
      variants: <VariantItem>[
        VariantItem(
          name: 'Home V1 - Basic',
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
                // Using Wrap to display variants flexibly, allowing them to flow to new lines.
                Wrap(
                  spacing: 24.0, // Horizontal space between variant cards
                  runSpacing:
                      24.0, // Vertical space between rows of variant cards
                  alignment: WrapAlignment
                      .center, // Center the cards if there's extra space
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

/// The root application widget.
class LegacyMyApp extends StatelessWidget {
  const LegacyMyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UI Variants Showcase',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          elevation: 4,
          titleTextStyle: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        cardTheme: CardThemeData(
          // Fix: Changed CardTheme to CardThemeData
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      home: VariantDashboardPage(),
    );
  }
}
