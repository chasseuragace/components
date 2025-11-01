import 'package:flutter/material.dart';

class InterviewScheduleScreen3 extends StatelessWidget {
  const InterviewScheduleScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(height: 20),
              AestheticInterviewCard(),
              SizedBox(height: 20),
              AestheticInterviewCard(
                jobTitle: "Electrician",
                companyName: "Dubai Power",
                companyLogo: "D",
                salary: "\$95k - \$130k",
                interviewType: "On-site",
                interviewRound: "Final Round",
                interviewDate: "Tomorrow",
                interviewTime: "2:00 PM",
                interviewFormat: "Discussion",
                status: "Confirmed",
                statusColor: Color(0xFF10B981),
                applicationDate: "Applied 2 weeks ago",
                accentColor: Color(0xFF8B5CF6),
              ),
              SizedBox(height: 20),
              AestheticInterviewCard(
                jobTitle: "Plumber",
                companyName: "Saudi Housing",
                companyLogo: "S",
                salary: "\$120k - \$160k",
                interviewType: "Remote",
                interviewRound: "HR Round",
                interviewDate: "Friday",
                interviewTime: "10:00 AM",
                interviewFormat: "Phone Interview",
                status: "Pending",
                statusColor: Color(0xFFF59E0B),
                applicationDate: "Applied 5 days ago",
                accentColor: Color(0xFF06B6D4),
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class AestheticInterviewCard extends StatelessWidget {
  final String jobTitle;
  final String companyName;
  final String companyLogo;
  final String salary;
  final String interviewType;
  final String interviewRound;
  final String interviewDate;
  final String interviewTime;
  final String interviewFormat;
  final String status;
  final Color statusColor;
  final String applicationDate;
  final Color accentColor;

  const AestheticInterviewCard({
    super.key,
    this.jobTitle = "Construction Worker",
    this.companyName = "Qatar Company",
    this.companyLogo = "Q",
    this.salary = "\$85k - \$120k",
    this.interviewType = "Remote",
    this.interviewRound = "First Round",
    this.interviewDate = "Today",
    this.interviewTime = "3:30 PM",
    this.interviewFormat = "Video Call",
    this.status = "Scheduled",
    this.statusColor = const Color(0xFF3B82F6),
    this.applicationDate = "Applied 1 week ago",
    this.accentColor = const Color(0xFF6366F1),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF64748B).withOpacity(0.08),
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
          BoxShadow(
            color: accentColor.withOpacity(0.04),
            blurRadius: 32,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Padding(
            padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: Row(
              children: [
                // Company Logo
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: accentColor.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      companyLogo,
                      style: TextStyle(
                        fontSize: companyLogo.contains('🍎') ? 24 : 20,
                        fontWeight: FontWeight.w700,
                        color: companyLogo.contains('🍎') ? null : accentColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                // Company and Job Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        companyName,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF64748B),
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        jobTitle,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0F172A),
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                // Status Badge
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20),

          // Salary Section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    accentColor.withOpacity(0.05),
                    accentColor.withOpacity(0.02),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: accentColor.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: accentColor.withOpacity(0.1),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.payments_outlined,
                      size: 20,
                      color: accentColor,
                    ),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Expected Salary',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        salary,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 20),

          // Interview Details Grid
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildDetailItem(
                        Icons.calendar_today_outlined,
                        'Date',
                        interviewDate,
                        accentColor,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildDetailItem(
                        Icons.access_time_outlined,
                        'Time',
                        interviewTime,
                        accentColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildDetailItem(
                        Icons.location_on_outlined,
                        'Type',
                        interviewType,
                        accentColor,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildDetailItem(
                        Icons.people_outline,
                        'Format',
                        interviewFormat,
                        accentColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildDetailItem(
                        Icons.layers_outlined,
                        'Round',
                        interviewRound,
                        accentColor,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildDetailItem(
                        Icons.history_outlined,
                        'Applied',
                        applicationDate.replaceAll('Applied ', ''),
                        accentColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 24),

          // Divider
          Container(
            height: 1,
            margin: EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Color(0xFFE2E8F0),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          SizedBox(height: 20),

          // Action Buttons
          Padding(
            padding: EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Column(
              children: [
                // Primary Action
                Container(
                  width: double.infinity,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [accentColor, accentColor.withOpacity(0.8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withOpacity(0.3),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () {},
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.videocam, color: Colors.white, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Join Interview',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 12),

                // Secondary Actions
                Row(
                  children: [
                    Expanded(
                      child: _buildSecondaryButton(
                        Icons.schedule,
                        'Reschedule',
                        accentColor,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: _buildSecondaryButton(
                        Icons.calendar_month,
                        'Add to Calendar',
                        accentColor,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: _buildSecondaryButton(
                        Icons.cancel_outlined,
                        'Cancel',
                        Color(0xFFEF4444),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE2E8F0), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF64748B),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F172A),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSecondaryButton(IconData icon, String text, Color color) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(color: color.withOpacity(0.2), width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {},
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: color, size: 16),
                SizedBox(width: 4),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
