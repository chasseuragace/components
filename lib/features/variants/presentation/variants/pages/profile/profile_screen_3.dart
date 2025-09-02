import 'package:flutter/material.dart';

class ProfileScreen3 extends StatelessWidget {
  const ProfileScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Job Candidate Profile',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'SF Pro Display',
        scaffoldBackgroundColor: Color(0xFFF2F2F7),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ProfileScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF00C7BE), // Teal background like the image
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => _showSettingsScreen(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.settings, color: Colors.white, size: 22),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF2F2F7),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileSection(),
            _buildStatsGrid(),
            _buildActivityChart(),
            _buildDetailsSections(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          // Profile Picture
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.network(
                'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
                fit: BoxFit.cover,
              ),
            ),
          ),

          SizedBox(height: 16),

          // Add CV/Resume Button
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Color(0xFFFF6B35),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, color: Colors.white, size: 16),
                SizedBox(width: 6),
                Text(
                  'Upload CV',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 16),

          // Name and Basic Info
          Text(
            'Rajesh Kumar',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1C1C1E),
            ),
          ),

          SizedBox(height: 4),

          Text(
            'rajesh.kumar@gmail.com',
            style: TextStyle(fontSize: 16, color: Color(0xFF8E8E93)),
          ),

          SizedBox(height: 16),

          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem('2.3K', 'Profile Views'),
              Container(width: 1, height: 40, color: Color(0xFFE5E5EA)),
              _buildStatItem('47', 'Applications'),
              Container(width: 1, height: 40, color: Color(0xFFE5E5EA)),
              _buildStatItem('12', 'Interviews'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1C1C1E),
          ),
        ),
        SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: Color(0xFF8E8E93))),
      ],
    );
  }

  Widget _buildStatsGrid() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              '23',
              'Jobs Applied',
              Icons.work_outline,
              Color(0xFFFFD60A),
              Color(0xFFFFF8DC),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              '8',
              'Interviews',
              Icons.people_outline,
              Color(0xFFFF6B35),
              Color(0xFFFFF0E6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String value,
    String label,
    IconData icon,
    Color iconColor,
    Color bgColor,
  ) {
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
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1C1C1E),
            ),
          ),
          SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, color: Color(0xFF8E8E93))),
        ],
      ),
    );
  }

  Widget _buildActivityChart() {
    return Container(
      margin: EdgeInsets.all(24),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Job Applications',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1C1C1E),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Weekly Activity',
                    style: TextStyle(fontSize: 12, color: Color(0xFF8E8E93)),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Color(0xFFFFD60A).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Active',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFFF8500),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 20),

          // Simple Bar Chart
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildBarItem('Mon', 25),
              _buildBarItem('Tue', 40),
              _buildBarItem('Wed', 30),
              _buildBarItem('Thu', 35),
              _buildBarItem('Fri', 45),
              _buildBarItem('Sat', 20),
              _buildBarItem('Sun', 15),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBarItem(String day, double height) {
    return Column(
      children: [
        Container(
          width: 20,
          height: height,
          decoration: BoxDecoration(
            color: day == 'Fri' ? Color(0xFFFF6B35) : Color(0xFFFFD60A),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(height: 8),
        Text(day, style: TextStyle(fontSize: 10, color: Color(0xFF8E8E93))),
      ],
    );
  }

  Widget _buildDetailsSections() {
    return Column(
      children: [
        _buildSectionHeader('Personal Information'),
        _buildPersonalInfoSection(),
        _buildSectionHeader('Professional Details'),
        _buildProfessionalSection(),
        _buildSectionHeader('Qualifications'),
        _buildQualificationsSection(),
        SizedBox(height: 100), // Bottom padding
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1C1C1E),
        ),
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
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
          _buildDetailRow(
            Icons.email_outlined,
            'Email',
            'rajesh.kumar@gmail.com',
          ),
          _buildDetailRow(Icons.phone_outlined, 'Phone', '+977 9841234567'),
          _buildDetailRow(Icons.home_outlined, 'Address', 'Kathmandu, Nepal'),
          _buildDetailRow(
            Icons.cake_outlined,
            'Date of Birth',
            'March 15, 1995',
          ),
          _buildDetailRow(Icons.wc_outlined, 'Gender', 'Male'),
          _buildDetailRow(
            Icons.family_restroom_outlined,
            'Marital Status',
            'Single',
          ),
        ],
      ),
    );
  }

  Widget _buildProfessionalSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
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
          _buildDetailRow(Icons.work_outline, 'Experience', '3 years'),
          _buildDetailRow(Icons.star_outline, 'Preferred Role', 'Chef / Cook'),
          _buildDetailRow(
            Icons.location_on_outlined,
            'Preferred Country',
            'UAE, Qatar',
          ),
          _buildDetailRow(
            Icons.attach_money,
            'Expected Salary',
            'USD 800-1200/month',
          ),
          _buildDetailRow(
            Icons.schedule_outlined,
            'Availability',
            'Immediately',
          ),
          _buildDetailRow(
            Icons.card_membership,
            'Work Permit',
            'Ready to Apply',
          ),
        ],
      ),
    );
  }

  Widget _buildQualificationsSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
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
          _buildDetailRow(
            Icons.school_outlined,
            'Education',
            'High School Graduate',
          ),
          _buildDetailRow(
            Icons.military_tech_outlined,
            'Training',
            'Culinary Arts Certificate',
          ),
          _buildDetailRow(
            Icons.language_outlined,
            'Languages',
            'Nepali, Hindi, English',
          ),
          _buildDetailRow(
            Icons.verified_outlined,
            'Licenses',
            'Food Handler Certificate',
          ),
          _buildDetailRow(
            Icons.health_and_safety_outlined,
            'Medical',
            'Health Certificate Valid',
          ),
          _buildDetailRow(
            Icons.badge_outlined,
            'Skills',
            'Cooking, Food Prep, Kitchen Management',
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFF2F2F7), width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Color(0xFFF2F2F7),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: Color(0xFF00C7BE)),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF8E8E93),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF1C1C1E),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: Color(0xFFD1D1D6), size: 20),
        ],
      ),
    );
  }

  void _showSettingsScreen(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(
          color: Color(0xFFF2F2F7),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: _buildSettingsContent(context),
      ),
    );
  }

  Widget _buildSettingsContent(BuildContext context) {
    return Column(
      children: [
        // Settings Header
        Container(
          padding: EdgeInsets.all(24),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.arrow_back_ios, color: Color(0xFF007AFF)),
              ),
              SizedBox(width: 16),
              Text(
                'Settings',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1C1C1E),
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildSettingsSection([
                  _buildSettingsRow(Icons.email_outlined, 'Email', ''),
                  _buildSettingsRow(Icons.person_outline, 'Username', ''),
                  _buildSettingsRow(Icons.security, 'Step data source', ''),
                  _buildSettingsRow(Icons.language, 'Language', ''),
                  _buildSettingsRow(Icons.privacy_tip_outlined, 'Privacy', ''),
                ]),

                SizedBox(height: 24),

                _buildSettingsSection([
                  _buildSettingsRow(
                    Icons.diamond_outlined,
                    'Premium Status',
                    'Inactive',
                    isHighlight: true,
                  ),
                ]),

                SizedBox(height: 24),

                // Referral Section
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 24),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFFF6B35), Color(0xFFFF8500)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Refer a friend',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '50 referrals',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Panda characters
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: Stack(
                          children: [
                            Positioned(
                              right: 20,
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '🐼',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '🐼',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24),

                _buildSettingsSection([
                  _buildSettingsRow(Icons.apps, 'App Icon', ''),
                  _buildSettingsRow(Icons.widgets_outlined, 'Widget', ''),
                ]),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsSection(List<Widget> children) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
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
      child: Column(children: children),
    );
  }

  Widget _buildSettingsRow(
    IconData icon,
    String title,
    String subtitle, {
    bool isHighlight = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFF2F2F7), width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 22,
            color: isHighlight ? Color(0xFF007AFF) : Color(0xFF8E8E93),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF1C1C1E),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (subtitle.isNotEmpty) ...[
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: isHighlight ? Color(0xFFFF8500) : Color(0xFF8E8E93),
                fontWeight: isHighlight ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
            SizedBox(width: 8),
          ],
          Icon(Icons.chevron_right, color: Color(0xFFD1D1D6), size: 20),
        ],
      ),
    );
  }
}
