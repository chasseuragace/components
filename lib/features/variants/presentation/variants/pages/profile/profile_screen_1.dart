import 'package:flutter/material.dart';

class ProfileScreen1 extends StatelessWidget {
  const ProfileScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile Page',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ProfilePage(),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {},
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Stack(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    "https://i.pravatar.cc/150?img=3",
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Center(
            child: Text(
              "Jack William",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const Center(
            child: Text(
              "jackwilliam1704@gmail.com",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 24),

          // Basic Details
          _ProfileSection(
            title: "Basic Details",
            children: [
              _ProfileItem(
                label: "Email",
                subtitle: "jackwilliam1704@gmail.com",
              ),
              _ProfileItem(label: "Phone", subtitle: "+971 55 123 4567"),
              _ProfileItem(label: "Home Address", subtitle: "Dubai, UAE"),
            ],
          ),

          // Experience
          _ProfileSection(
            title: "Experience",
            children: [
              _ProfileItem(label: "Current Role", subtitle: "Senior Chef"),
              _ProfileItem(label: "Years of Experience", subtitle: "5 Years"),
            ],
          ),

          // Training
          _ProfileSection(
            title: "Training",
            children: [
              _ProfileItem(
                label: "Completed",
                subtitle: "Food Safety Training",
              ),
            ],
          ),

          // Education
          _ProfileSection(
            title: "Education",
            children: [
              _ProfileItem(
                label: "Highest Qualification",
                subtitle: "Diploma in Culinary Arts",
              ),
            ],
          ),

          // Language
          _ProfileSection(
            title: "Language",
            children: [
              _ProfileItem(label: "Primary Language", subtitle: "English"),
              _ProfileItem(label: "Secondary Language", subtitle: "Nepali"),
            ],
          ),

          // Driving License
          _ProfileSection(
            title: "Driving License",
            children: [
              _ProfileItem(label: "License Number", subtitle: "DL-12345678"),
              _ProfileItem(label: "Country", subtitle: "UAE"),
            ],
          ),
        ],
      ),
    );
  }
}

// ----------------- Widgets -----------------
class _ProfileSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _ProfileSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _ProfileItem extends StatelessWidget {
  final String label;
  final String subtitle;
  const _ProfileItem({required this.label, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.edit, color: Colors.blue),
      onTap: () {
        // Edit functionality here
      },
    );
  }
}
