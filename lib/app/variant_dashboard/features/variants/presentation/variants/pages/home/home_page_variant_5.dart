import 'package:flutter/material.dart';

class HomePageVariant5 extends StatelessWidget {
  const HomePageVariant5({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JobFlow',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'SF Pro Display',
      ),
      home: MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    DashboardScreen(),
    JobsScreen(),
    ProfileScreen(),
    AnalyticsScreen(),
    PreferencesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.blue[600],
          unselectedItemColor: Colors.grey[600],
          backgroundColor: Colors.white,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.work_outline),
              activeIcon: Icon(Icons.work),
              label: 'Jobs',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.analytics_outlined),
              activeIcon: Icon(Icons.analytics),
              label: 'Analytics',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings),
              label: 'Preferences',
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with profile
              _buildHeader(),
              SizedBox(height: 24),

              // Welcome Card
              _buildWelcomeCard(),
              SizedBox(height: 24),

              // Quick Stats
              _buildQuickStats(),
              SizedBox(height: 24),

              // Quick Actions
              _buildQuickActions(context),
              SizedBox(height: 24),

              // Recent Activity
              _buildRecentActivity(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundImage: NetworkImage(
            'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good morning, Alex!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'Ready to find your dream job?',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            ],
          ),
        ),
        IconButton(
          icon: Stack(
            children: [
              Icon(Icons.notifications_outlined),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[600]!, Colors.purple[600]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Job Search',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '23 applications sent • 7 interviews scheduled',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.blue[600],
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('View All Applications'),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard('Profile Views', '1,247', '+12%', Colors.blue),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildStatCard('Applications', '23', '+3', Colors.green),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildStatCard('Response Rate', '34%', '+5%', Colors.orange),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    String change,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            change,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                'Browse Jobs',
                'Find your perfect match',
                Icons.work_outline,
                Colors.blue,
                () {},
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                'Update Profile',
                'Keep info current',
                Icons.person_outline,
                Colors.green,
                () {},
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildActivityItem(
                'Applied to Frontend Developer',
                'TechCorp • 2 hours ago',
                Icons.work,
                Colors.blue,
              ),
              Divider(height: 1),
              _buildActivityItem(
                'Profile viewed by 12 recruiters',
                'Yesterday',
                Icons.visibility,
                Colors.green,
              ),
              Divider(height: 1),
              _buildActivityItem(
                'Interview scheduled',
                'StartupX • Tomorrow at 2 PM',
                Icons.calendar_today,
                Colors.orange,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem(
    String title,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class JobsScreen extends StatefulWidget {
  const JobsScreen({super.key});

  @override
  _JobsScreenState createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  List<String> selectedCountries = ['Remote', 'United States'];
  double minSalary = 50000;
  double maxSalary = 150000;
  String combineWith = 'OR';
  bool showFilters = false;

  // Mock job data
  List<Job> jobs = [
    Job(
      id: 1,
      title: 'Senior React Developer',
      company: 'TechFlow Inc.',
      location: 'Remote',
      salary: '\$90K - \$130K',
      type: 'Full-time',
      posted: '2 days ago',
      match: 95,
      description:
          'Join our dynamic team building next-gen web applications with React, TypeScript, and modern tools.',
      tags: ['React', 'TypeScript', 'Node.js', 'AWS'],
      logo:
          'https://images.unsplash.com/photo-1549924231-f129b911e442?w=60&h=60&fit=crop',
    ),
    Job(
      id: 2,
      title: 'Frontend Engineer',
      company: 'Innovate Labs',
      location: 'San Francisco, CA',
      salary: '\$95K - \$140K',
      type: 'Full-time',
      posted: '1 day ago',
      match: 88,
      description:
          'Looking for a passionate frontend engineer to help us build beautiful, responsive user interfaces.',
      tags: ['Vue.js', 'JavaScript', 'CSS3', 'GraphQL'],
      logo:
          'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=60&h=60&fit=crop',
    ),
    Job(
      id: 3,
      title: 'Full Stack Developer',
      company: 'StartupX',
      location: 'Austin, TX',
      salary: '\$80K - \$120K',
      type: 'Full-time',
      posted: '3 days ago',
      match: 82,
      description:
          'Help us scale our platform with modern web technologies and cloud infrastructure.',
      tags: ['React', 'Python', 'PostgreSQL', 'Docker'],
      logo:
          'https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=60&h=60&fit=crop',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recommended Jobs'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () => setState(() => showFilters = !showFilters),
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => _showSearchDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          if (showFilters) _buildFiltersSection(),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: jobs.length,
              itemBuilder: (context, index) => _buildJobCard(jobs[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersSection() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filters',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),

          // Country Filter
          Text('Countries', style: TextStyle(fontWeight: FontWeight.w500)),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: ['Remote', 'United States', 'Canada', 'United Kingdom']
                .map(
                  (country) => FilterChip(
                    label: Text(country),
                    selected: selectedCountries.contains(country),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          selectedCountries.add(country);
                        } else {
                          selectedCountries.remove(country);
                        }
                      });
                    },
                  ),
                )
                .toList(),
          ),
          SizedBox(height: 16),

          // Salary Filter
          Text('Salary Range', style: TextStyle(fontWeight: FontWeight.w500)),
          SizedBox(height: 8),
          RangeSlider(
            values: RangeValues(minSalary, maxSalary),
            min: 30000,
            max: 200000,
            divisions: 17,
            labels: RangeLabels(
              '\$${(minSalary / 1000).round()}K',
              '\$${(maxSalary / 1000).round()}K',
            ),
            onChanged: (values) {
              setState(() {
                minSalary = values.start;
                maxSalary = values.end;
              });
            },
          ),

          // Combine Option
          Row(
            children: [
              Text('Combine with: '),
              DropdownButton<String>(
                value: combineWith,
                items: ['AND', 'OR']
                    .map(
                      (value) =>
                          DropdownMenuItem(value: value, child: Text(value)),
                    )
                    .toList(),
                onChanged: (value) => setState(() => combineWith = value!),
              ),
            ],
          ),

          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _applyFilters,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              foregroundColor: Colors.white,
              minimumSize: Size(double.infinity, 44),
            ),
            child: Text('Apply Filters'),
          ),
        ],
      ),
    );
  }

  Widget _buildJobCard(Job job) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  job.logo,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            job.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${job.match}% match',
                            style: TextStyle(
                              color: Colors.green[800],
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      job.company,
                      style: TextStyle(
                        color: Colors.blue[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),

          Row(
            children: [
              Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
              SizedBox(width: 4),
              Text(
                job.location,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              SizedBox(width: 16),
              Icon(Icons.attach_money, size: 16, color: Colors.grey[600]),
              SizedBox(width: 4),
              Text(
                job.salary,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              SizedBox(width: 16),
              Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
              SizedBox(width: 4),
              Text(
                job.posted,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),

          SizedBox(height: 12),
          Text(
            job.description,
            style: TextStyle(color: Colors.grey[700], fontSize: 14),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: job.tags
                .map(
                  (tag) => Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(color: Colors.grey[700], fontSize: 11),
                    ),
                  ),
                )
                .toList(),
          ),

          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _applyToJob(job),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Apply Now'),
                ),
              ),
              SizedBox(width: 12),
              OutlinedButton(
                onPressed: () => _saveJob(job),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Icon(Icons.bookmark_border),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Search Jobs'),
        content: TextField(
          decoration: InputDecoration(
            hintText: 'Enter job title, company, or keywords...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Search'),
          ),
        ],
      ),
    );
  }

  void _applyFilters() {
    // Simulate API call - getRelevantJobs(candidateId, filters)
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Filters applied successfully!')));
  }

  void _applyToJob(Job job) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Applied to ${job.title} at ${job.company}!')),
    );
  }

  void _saveJob(Job job) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Job saved successfully!')));
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [IconButton(icon: Icon(Icons.edit), onPressed: () {})],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile Header
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Alex Rivera',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Senior Frontend Developer',
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      Text(
                        'San Francisco, CA',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Profile Sections
            _buildProfileSection('Contact Information', [
              _buildInfoRow(Icons.email, 'alex.rivera@email.com'),
              _buildInfoRow(Icons.phone, '+1 (555) 123-4567'),
              _buildInfoRow(Icons.link, 'linkedin.com/in/alexrivera'),
            ]),

            SizedBox(height: 16),

            _buildProfileSection('Skills', [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    [
                          'React',
                          'TypeScript',
                          'Node.js',
                          'Python',
                          'AWS',
                          'Docker',
                          'GraphQL',
                          'MongoDB',
                        ]
                        .map(
                          (skill) => Chip(
                            label: Text(skill),
                            backgroundColor: Colors.blue[50],
                            labelStyle: TextStyle(color: Colors.blue[800]),
                          ),
                        )
                        .toList(),
              ),
            ]),

            SizedBox(height: 16),

            _buildProfileSection('Experience', [
              _buildExperienceItem(
                'Senior Frontend Developer',
                'TechCorp Inc.',
                '2022 - Present',
                'Leading frontend development for enterprise applications using React and TypeScript.',
              ),
              _buildExperienceItem(
                'Frontend Developer',
                'StartupY',
                '2020 - 2022',
                'Built responsive web applications and improved user experience across multiple products.',
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(String title, List<Widget> children) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          SizedBox(width: 12),
          Text(text, style: TextStyle(color: Colors.grey[700])),
        ],
      ),
    );
  }

  Widget _buildExperienceItem(
    String title,
    String company,
    String duration,
    String description,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            '$company • $duration',
            style: TextStyle(
              color: Colors.blue[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(color: Colors.grey[700], fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Analytics'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // Main Stats Grid
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
              children: [
                _buildAnalyticsCard(
                  'Profile Views',
                  '1,247',
                  '+12%',
                  Icons.visibility,
                  Colors.blue,
                ),
                _buildAnalyticsCard(
                  'Applications',
                  '23',
                  '+3',
                  Icons.send,
                  Colors.green,
                ),
                _buildAnalyticsCard(
                  'Interviews',
                  '7',
                  '+2',
                  Icons.people,
                  Colors.purple,
                ),
                _buildAnalyticsCard(
                  'Response Rate',
                  '34%',
                  '+5%',
                  Icons.trending_up,
                  Colors.orange,
                ),
              ],
            ),

            SizedBox(height: 24),

            // Application Timeline
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Application Timeline',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  _buildTimelineItem(
                    'TechFlow Inc.',
                    'Senior React Developer',
                    'Interview Scheduled',
                    'Today',
                    Colors.green,
                  ),
                  _buildTimelineItem(
                    'Innovate Labs',
                    'Frontend Engineer',
                    'Under Review',
                    '2 days ago',
                    Colors.orange,
                  ),
                  _buildTimelineItem(
                    'StartupX',
                    'Full Stack Developer',
                    'Applied',
                    '1 week ago',
                    Colors.blue,
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            // Weekly Progress
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Weekly Progress',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  _buildProgressItem('Job Applications', 5, 10, Colors.blue),
                  _buildProgressItem('Profile Updates', 2, 3, Colors.green),
                  _buildProgressItem(
                    'Network Connections',
                    8,
                    15,
                    Colors.purple,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticsCard(
    String title,
    String value,
    String change,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
            ],
          ),
          Spacer(),
          Text(
            value,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          SizedBox(height: 4),
          Text(
            change,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(
    String company,
    String position,
    String status,
    String date,
    Color statusColor,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(position, style: TextStyle(fontWeight: FontWeight.w600)),
                Text(
                  company,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 4),
              Text(
                date,
                style: TextStyle(color: Colors.grey[500], fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressItem(
    String title,
    int current,
    int target,
    Color color,
  ) {
    double progress = current / target;
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
              Text(
                '$current/$target',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
          SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ],
      ),
    );
  }
}

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  _PreferencesScreenState createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  List<String> preferredTitles = [
    'Frontend Developer',
    'React Developer',
    'Full Stack Developer',
  ];
  List<String> preferredCountries = ['Remote', 'United States', 'Canada'];
  List<String> workTypes = ['Remote', 'Hybrid'];
  double minSalary = 60000;
  double maxSalary = 140000;
  String experienceLevel = 'Senior';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Preferences'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [TextButton(onPressed: _savePreferences, child: Text('Save'))],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPreferenceSection(
              'Job Titles',
              'What roles are you looking for?',
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ...preferredTitles.map(
                    (title) => Chip(
                      label: Text(title),
                      onDeleted: () => _removeTitle(title),
                      backgroundColor: Colors.blue[50],
                      labelStyle: TextStyle(color: Colors.blue[800]),
                    ),
                  ),
                  ActionChip(
                    label: Text('+ Add Title'),
                    onPressed: () => _addTitle(context),
                    backgroundColor: Colors.grey[100],
                  ),
                ],
              ),
            ),

            _buildPreferenceSection(
              'Preferred Locations',
              'Where would you like to work?',
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ...preferredCountries.map(
                    (country) => Chip(
                      label: Text(country),
                      onDeleted: () => _removeCountry(country),
                      backgroundColor: Colors.green[50],
                      labelStyle: TextStyle(color: Colors.green[800]),
                    ),
                  ),
                  ActionChip(
                    label: Text('+ Add Location'),
                    onPressed: () => _addCountry(context),
                    backgroundColor: Colors.grey[100],
                  ),
                ],
              ),
            ),

            _buildPreferenceSection(
              'Salary Range (USD)',
              'What\'s your expected salary?',
              Column(
                children: [
                  RangeSlider(
                    values: RangeValues(minSalary, maxSalary),
                    min: 30000,
                    max: 200000,
                    divisions: 17,
                    labels: RangeLabels(
                      '\${(minSalary / 1000).round()}K',
                      '\${(maxSalary / 1000).round()}K',
                    ),
                    onChanged: (values) {
                      setState(() {
                        minSalary = values.start;
                        maxSalary = values.end;
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\${(minSalary / 1000).round()}K',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '\${(maxSalary / 1000).round()}K',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            _buildPreferenceSection(
              'Work Type',
              'How do you prefer to work?',
              Wrap(
                spacing: 8,
                children: ['Remote', 'Hybrid', 'On-site']
                    .map(
                      (type) => FilterChip(
                        label: Text(type),
                        selected: workTypes.contains(type),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              workTypes.add(type);
                            } else {
                              workTypes.remove(type);
                            }
                          });
                        },
                        backgroundColor: Colors.purple[50],
                        selectedColor: Colors.purple[100],
                        labelStyle: TextStyle(
                          color: workTypes.contains(type)
                              ? Colors.purple[800]
                              : Colors.grey[700],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),

            _buildPreferenceSection(
              'Experience Level',
              'What\'s your experience level?',
              DropdownButtonFormField<String>(
                value: experienceLevel,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                items:
                    ['Entry Level', 'Mid Level', 'Senior', 'Lead', 'Executive']
                        .map(
                          (level) => DropdownMenuItem(
                            value: level,
                            child: Text(level),
                          ),
                        )
                        .toList(),
                onChanged: (value) => setState(() => experienceLevel = value!),
              ),
            ),

            SizedBox(height: 32),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _savePreferences,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Save Preferences',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreferenceSection(
    String title,
    String subtitle,
    Widget content,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
          SizedBox(height: 16),
          content,
        ],
      ),
    );
  }

  void _removeTitle(String title) {
    setState(() {
      preferredTitles.remove(title);
    });
  }

  void _removeCountry(String country) {
    setState(() {
      preferredCountries.remove(country);
    });
  }

  void _addTitle(BuildContext context) {
    _showAddDialog(context, 'Add Job Title', (value) {
      setState(() {
        preferredTitles.add(value);
      });
    });
  }

  void _addCountry(BuildContext context) {
    _showAddDialog(context, 'Add Location', (value) {
      setState(() {
        preferredCountries.add(value);
      });
    });
  }

  void _showAddDialog(
    BuildContext context,
    String title,
    Function(String) onAdd,
  ) {
    String inputValue = '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          onChanged: (value) => inputValue = value,
          decoration: InputDecoration(
            hintText: 'Enter $title...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (inputValue.isNotEmpty) {
                onAdd(inputValue);
                Navigator.pop(context);
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  void _savePreferences() {
    // Simulate API call to save preferences
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Preferences saved successfully!'),
        backgroundColor: Colors.green[600],
      ),
    );
  }
}

// Job Model
class Job {
  final int id;
  final String title;
  final String company;
  final String location;
  final String salary;
  final String type;
  final String posted;
  final int match;
  final String description;
  final List<String> tags;
  final String logo;

  Job({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.salary,
    required this.type,
    required this.posted,
    required this.match,
    required this.description,
    required this.tags,
    required this.logo,
  });
}

// Additional utility functions for API simulation
class JobService {
  static Future<List<Job>> getRelevantJobs(
    int candidateId, {
    List<String>? countries,
    Map<String, double>? salary,
    String? combineWith,
    int? page,
    int? limit,
  }) async {
    // Simulate API delay
    await Future.delayed(Duration(milliseconds: 800));

    // Mock API response based on filters
    List<Job> allJobs = [
      Job(
        id: 1,
        title: 'Senior React Developer',
        company: 'TechFlow Inc.',
        location: 'Remote',
        salary: '\$90K - \$130K',
        type: 'Full-time',
        posted: '2 days ago',
        match: 95,
        description:
            'Join our dynamic team building next-gen web applications with React, TypeScript, and modern tools.',
        tags: ['React', 'TypeScript', 'Node.js', 'AWS'],
        logo:
            'https://images.unsplash.com/photo-1549924231-f129b911e442?w=60&h=60&fit=crop',
      ),
      // Add more mock jobs as needed
    ];

    // Apply filters based on CandidatePreference logic
    List<Job> filteredJobs = allJobs;

    if (countries != null && countries.isNotEmpty) {
      if (combineWith == 'AND') {
        filteredJobs = filteredJobs
            .where(
              (job) =>
                  countries.every((country) => job.location.contains(country)),
            )
            .toList();
      } else {
        filteredJobs = filteredJobs
            .where(
              (job) =>
                  countries.any((country) => job.location.contains(country)),
            )
            .toList();
      }
    }

    return filteredJobs;
  }
}

class CandidatePreference {
  final List<String> preferredTitles;
  final List<String> preferredCountries;
  final Map<String, dynamic> salaryRange;
  final List<String> workType;
  final String experienceLevel;

  CandidatePreference({
    required this.preferredTitles,
    required this.preferredCountries,
    required this.salaryRange,
    required this.workType,
    required this.experienceLevel,
  });

  factory CandidatePreference.fromJson(Map<String, dynamic> json) {
    return CandidatePreference(
      preferredTitles: List<String>.from(json['preferredTitles'] ?? []),
      preferredCountries: List<String>.from(json['preferredCountries'] ?? []),
      salaryRange: json['salaryRange'] ?? {},
      workType: List<String>.from(json['workType'] ?? []),
      experienceLevel: json['experienceLevel'] ?? 'Mid Level',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'preferredTitles': preferredTitles,
      'preferredCountries': preferredCountries,
      'salaryRange': salaryRange,
      'workType': workType,
      'experienceLevel': experienceLevel,
    };
  }
}
