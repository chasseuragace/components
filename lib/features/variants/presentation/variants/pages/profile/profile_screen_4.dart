// import 'package:flutter/material.dart';

// class ProfileScreen2 extends StatelessWidget {
//   const ProfileScreen2({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Job Candidate Profile',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         scaffoldBackgroundColor: const Color(0xFFF8F9FA),
//       ),
//       home: const JobCandidateProfilePage(),
//     );
//   }
// }

// class JobCandidateProfilePage extends StatelessWidget {
//   const JobCandidateProfilePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F9FA),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.edit, color: Colors.black),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // Header Section with Profile Image and Basic Info
//             Container(
//               width: double.infinity,
//               color: Colors.white,
//               padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
//               child: Column(
//                 children: [
//                   const CircleAvatar(
//                     radius: 50,
//                     backgroundImage: NetworkImage(
//                       "https://i.pravatar.cc/150?img=47",
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   const Text(
//                     "Emma Phillips",
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   const Text(
//                     "Software Developer",
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Colors.grey,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   const SizedBox(height: 24),

//                   // Contact Info
//                   Row(
//                     children: [
//                       const Icon(Icons.phone, color: Colors.grey, size: 20),
//                       const SizedBox(width: 12),
//                       Text(
//                         "(580) 307-6902",
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: Colors.grey[700],
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 12),
//                   Row(
//                     children: [
//                       const Icon(Icons.email, color: Colors.grey, size: 20),
//                       const SizedBox(width: 12),
//                       Text(
//                         "emma.phillips@gmail.com",
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: Colors.grey[700],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 24),

//             // Job Statistics Cards
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 24),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: _StatCard(
//                       value: "24",
//                       label: "Jobs Applied",
//                       color: Colors.blue,
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: _StatCard(
//                       value: "8",
//                       label: "Interviews Scheduled",
//                       color: Colors.green,
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 16),

//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 24),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: _StatCard(
//                       value: "156",
//                       label: "Profile Views",
//                       color: Colors.orange,
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: _StatCard(
//                       value: "3",
//                       label: "Job Offers",
//                       color: Colors.purple,
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 32),

//             // Profile Menu Items
//             Container(
//               margin: const EdgeInsets.symmetric(horizontal: 24),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.05),
//                     blurRadius: 10,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 children: [
//                   _ProfileMenuItem(
//                     icon: Icons.person,
//                     title: "Personal Information",
//                     subtitle: "Update your personal details",
//                     iconColor: Colors.blue,
//                     onTap: () {},
//                   ),
//                   _ProfileMenuItem(
//                     icon: Icons.work,
//                     title: "Work Experience",
//                     subtitle: "Manage your work history",
//                     iconColor: Colors.green,
//                     onTap: () {},
//                   ),
//                   _ProfileMenuItem(
//                     icon: Icons.school,
//                     title: "Education & Training",
//                     subtitle: "Add your qualifications",
//                     iconColor: Colors.orange,
//                     onTap: () {},
//                   ),
//                   _ProfileMenuItem(
//                     icon: Icons.language,
//                     title: "Languages & Skills",
//                     subtitle: "Showcase your abilities",
//                     iconColor: Colors.purple,
//                     onTap: () {},
//                   ),
//                   _ProfileMenuItem(
//                     icon: Icons.card_membership,
//                     title: "Licenses & Certifications",
//                     subtitle: "Professional credentials",
//                     iconColor: Colors.teal,
//                     onTap: () {},
//                   ),
//                   _ProfileMenuItem(
//                     icon: Icons.settings,
//                     title: "Settings",
//                     subtitle: "Privacy and preferences",
//                     iconColor: Colors.grey,
//                     onTap: () {},
//                     showDivider: false,
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 32),

//             // Logout Button
//             Container(
//               margin: const EdgeInsets.symmetric(horizontal: 24),
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {},
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.red[50],
//                   foregroundColor: Colors.red,
//                   elevation: 0,
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.logout, color: Colors.red[600]),
//                     const SizedBox(width: 8),
//                     Text(
//                       "Log out",
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.red[600],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             const SizedBox(height: 32),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _StatCard extends StatelessWidget {
//   final String value;
//   final String label;
//   final Color color;

//   const _StatCard({
//     required this.value,
//     required this.label,
//     required this.color,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 28,
//               fontWeight: FontWeight.bold,
//               color: color,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             label,
//             style: const TextStyle(
//               fontSize: 14,
//               color: Colors.grey,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _ProfileMenuItem extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final String subtitle;
//   final Color iconColor;
//   final VoidCallback onTap;
//   final bool showDivider;

//   const _ProfileMenuItem({
//     required this.icon,
//     required this.title,
//     required this.subtitle,
//     required this.iconColor,
//     required this.onTap,
//     this.showDivider = true,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         ListTile(
//           contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//           leading: Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: iconColor.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Icon(
//               icon,
//               color: iconColor,
//               size: 24,
//             ),
//           ),
//           title: Text(
//             title,
//             style: const TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               color: Colors.black87,
//             ),
//           ),
//           subtitle: Text(
//             subtitle,
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.grey[600],
//             ),
//           ),
//           trailing: Icon(
//             Icons.arrow_forward_ios,
//             size: 16,
//             color: Colors.grey[400],
//           ),
//           onTap: onTap,
//         ),
//         if (showDivider)
//           Divider(
//             height: 1,
//             indent: 68,
//             endIndent: 20,
//             color: Colors.grey[200],
//           ),
//       ],
//     );
//   }
// }
