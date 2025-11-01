import 'package:flutter/material.dart';

class InterviewSchedule {
  final String jobTitle;
  final String companyName;
  final String companyLogo;
  final String interviewType;
  final String interviewRound;
  final DateTime dateTime;
  final String duration;
  final String location;
  final String interviewer;
  final String interviewerRole;
  final String status;
  final String priority;
  final String salaryRange;
  final Color statusColor;
  final IconData statusIcon;
  final Color primaryColor;
  final Color secondaryColor;

  InterviewSchedule({
    required this.jobTitle,
    required this.companyName,
    required this.companyLogo,
    required this.interviewType,
    required this.interviewRound,
    required this.dateTime,
    required this.duration,
    required this.location,
    required this.interviewer,
    required this.interviewerRole,
    required this.status,
    required this.priority,
    required this.salaryRange,
    required this.statusColor,
    required this.statusIcon,
    required this.primaryColor,
    required this.secondaryColor,
  });
}

class InterviewScheduleScreen2 extends StatefulWidget {
  const InterviewScheduleScreen2({super.key});

  @override
  _InterviewScheduleScreen2State createState() =>
      _InterviewScheduleScreen2State();
}

class _InterviewScheduleScreen2State extends State<InterviewScheduleScreen2> {
  final TextEditingController _searchController = TextEditingController();
  List<InterviewSchedule> _allInterviews = [];
  List<InterviewSchedule> _filteredInterviews = [];

  @override
  void initState() {
    super.initState();
    _loadSampleData();
    _filteredInterviews = _allInterviews;
  }

  void _loadSampleData() {
    _allInterviews = [
      InterviewSchedule(
        jobTitle: "Construction Worker",
        companyName: "Qatar Build Co.",
        companyLogo: "QB",
        interviewType: "In-Person",
        interviewRound: "Skill Test",
        dateTime: DateTime.now().add(const Duration(days: 2)),
        duration: "2h 0m",
        location: "Doha, Qatar",
        interviewer: "Mohammed Al-Sayed",
        interviewerRole: "Site Supervisor",
        status: "Confirmed",
        priority: "High",
        salaryRange: "QAR 2,000 - QAR 2,500",
        statusColor: Colors.blue.shade500,
        statusIcon: Icons.verified,
        primaryColor: Colors.blue.shade600,
        secondaryColor: Colors.blue.shade100,
      ),
      InterviewSchedule(
        jobTitle: "Electrician",
        companyName: "Dubai Power Services",
        companyLogo: "DP",
        interviewType: "Video Call",
        interviewRound: "Technical Round",
        dateTime: DateTime.now().add(const Duration(days: 4)),
        duration: "1h 30m",
        location: "Zoom Meeting",
        interviewer: "Rashid Khan",
        interviewerRole: "Electrical Engineer",
        status: "Scheduled",
        priority: "Medium",
        salaryRange: "AED 2,200 - AED 2,800",
        statusColor: Colors.blue.shade500,
        statusIcon: Icons.schedule,
        primaryColor: Colors.blue.shade600,
        secondaryColor: Colors.blue.shade100,
      ),
      InterviewSchedule(
        jobTitle: "Plumber",
        companyName: "Saudi Housing Corp.",
        companyLogo: "SH",
        interviewType: "Phone Call",
        interviewRound: "HR Round",
        dateTime: DateTime.now().add(const Duration(days: 1)),
        duration: "45m",
        location: "Phone Interview",
        interviewer: "Fatima Al-Harbi",
        interviewerRole: "HR Manager",
        status: "Pending",
        priority: "Low",
        salaryRange: "SAR 1,800 - SAR 2,200",
        statusColor: Colors.blue.shade600,
        statusIcon: Icons.pending,
        primaryColor: Colors.teal.shade600,
        secondaryColor: Colors.teal.shade100,
      ),
      InterviewSchedule(
        jobTitle: "Heavy Vehicle Driver",
        companyName: "Gulf Transport LLC",
        companyLogo: "GT",
        interviewType: "In-Person",
        interviewRound: "Driving Test",
        dateTime: DateTime.now().add(const Duration(days: 6)),
        duration: "3h 0m",
        location: "Abu Dhabi, UAE",
        interviewer: "Omar Al-Farsi",
        interviewerRole: "Fleet Manager",
        status: "Rescheduled",
        priority: "High",
        salaryRange: "AED 2,500 - AED 3,200",
        statusColor: Colors.blue.shade600,
        statusIcon: Icons.update,
        primaryColor: Colors.indigo.shade600,
        secondaryColor: Colors.indigo.shade100,
      ),
      InterviewSchedule(
        jobTitle: "Waiter",
        companyName: "Doha Star Hotel",
        companyLogo: "DS",
        interviewType: "Panel Interview",
        interviewRound: "Final Round",
        dateTime: DateTime.now().add(const Duration(days: 3)),
        duration: "1h 15m",
        location: "Hotel Conference Room",
        interviewer: "Ahmed Karim",
        interviewerRole: "Restaurant Manager",
        status: "Confirmed",
        priority: "High",
        salaryRange: "QAR 1,600 - QAR 2,000 + Tips",
        statusColor: Colors.blue.shade600,
        statusIcon: Icons.check_circle,
        primaryColor: Colors.blue.shade600,
        secondaryColor: Colors.blue.shade100,
      ),
    ];
  }

  void _filterInterviews(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredInterviews = _allInterviews;
      } else {
        _filteredInterviews = _allInterviews.where((interview) {
          return interview.jobTitle.toLowerCase().contains(
                query.toLowerCase(),
              ) ||
              interview.companyName.toLowerCase().contains(
                query.toLowerCase(),
              ) ||
              interview.interviewer.toLowerCase().contains(
                query.toLowerCase(),
              ) ||
              interview.status.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  String _formatDateTime(DateTime dateTime) {
    List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    String month = months[dateTime.month - 1];
    String day = dateTime.day.toString();
    String time =
        "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
    return "$day $month • $time";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white, Colors.purple.shade50],
            stops: [0.0, 0.3, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header Section
              Container(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.blue.shade600,
                                Colors.purple.shade600,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.shade200,
                                blurRadius: 12,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.calendar_today,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Interview Schedule',
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              '${_filteredInterviews.length} upcoming interviews',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    // Enhanced Search Bar
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.shade100.withOpacity(0.5),
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: _filterInterviews,
                        style: TextStyle(color: Colors.grey[800], fontSize: 15),
                        decoration: InputDecoration(
                          hintText: 'Search interviews...',
                          hintStyle: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 15,
                          ),
                          prefixIcon: Container(
                            padding: EdgeInsets.all(12),
                            child: Icon(
                              Icons.search,
                              color: Colors.blue[600],
                              size: 20,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Interview List
              Expanded(
                child: _filteredInterviews.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        itemCount: _filteredInterviews.length,
                        itemBuilder: (context, index) {
                          return BeautifulInterviewCard(
                            interview: _filteredInterviews[index],
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade100, Colors.purple.shade100],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.search_off, size: 48, color: Colors.grey[600]),
          ),
          SizedBox(height: 20),
          Text(
            'No interviews found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[700],
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Try adjusting your search terms',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}

class BeautifulInterviewCard extends StatelessWidget {
  final InterviewSchedule interview;

  const BeautifulInterviewCard({super.key, required this.interview});

  String _formatDateTime(DateTime dateTime) {
    List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    String month = months[dateTime.month - 1];
    String day = dateTime.day.toString();
    String time =
        "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
    return "$day $month • $time";
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red.shade500;
      case 'medium':
        return Colors.orange.shade500;
      case 'low':
        return Colors.blue.shade500;
      default:
        return Colors.grey.shade500;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: interview.primaryColor.withOpacity(0.1),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, interview.secondaryColor.withOpacity(0.3)],
            ),
            border: Border.all(
              color: interview.primaryColor.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              // Colored top border
              Container(
                height: 4,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      interview.primaryColor,
                      interview.primaryColor.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Row
                    Row(
                      children: [
                        // Enhanced Company Avatar
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                interview.primaryColor,
                                interview.primaryColor.withOpacity(0.8),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: interview.primaryColor.withOpacity(0.3),
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              interview.companyLogo,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        // Job Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                interview.jobTitle,
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey[800],
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                interview.companyName,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Enhanced Status Badge
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: interview.statusColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: interview.statusColor.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                interview.statusIcon,
                                size: 14,
                                color: interview.statusColor,
                              ),
                              SizedBox(width: 4),
                              Text(
                                interview.status,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: interview.statusColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20),

                    // Enhanced Interview Details
                    Container(
                      padding: EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.8),
                            interview.secondaryColor.withOpacity(0.4),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: interview.primaryColor.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _buildDetailItem(
                                  Icons.schedule,
                                  _formatDateTime(interview.dateTime),
                                  interview.primaryColor,
                                ),
                              ),
                              Container(
                                width: 2,
                                height: 20,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      interview.primaryColor.withOpacity(0.3),
                                      interview.primaryColor.withOpacity(0.1),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: _buildDetailItem(
                                  Icons.access_time,
                                  interview.duration,
                                  interview.primaryColor,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(
                                child: _buildDetailItem(
                                  Icons.videocam,
                                  interview.interviewType,
                                  interview.primaryColor,
                                ),
                              ),
                              Container(
                                width: 2,
                                height: 20,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      interview.primaryColor.withOpacity(0.3),
                                      interview.primaryColor.withOpacity(0.1),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: _buildDetailItem(
                                  Icons.layers,
                                  interview.interviewRound,
                                  interview.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 18),

                    // Enhanced Interviewer and Salary Row
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Interviewer',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: interview.primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                interview.interviewer,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[800],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                interview.interviewerRole,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.green.shade50,
                                Colors.blue.shade50,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.green.shade200,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Salary Range',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.green[700],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                interview.salaryRange,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.green[800],
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 18),

                    // Enhanced Priority and Actions Row
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _getPriorityColor(
                              interview.priority,
                            ).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _getPriorityColor(
                                interview.priority,
                              ).withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: _getPriorityColor(interview.priority),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: 6),
                              Text(
                                '${interview.priority} Priority',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: _getPriorityColor(interview.priority),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        _buildActionButton(
                          'Reschedule',
                          Icons.schedule,
                          Colors.grey[600]!,
                          Colors.grey[100]!,
                        ),
                        SizedBox(width: 10),
                        _buildActionButton(
                          'Join Call',
                          Icons.videocam,
                          Colors.white,
                          interview.primaryColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String text, Color color) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    String text,
    IconData icon,
    Color textColor,
    Color bgColor,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: bgColor != Colors.grey[100]!
            ? [
                BoxShadow(
                  color: bgColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ]
            : null,
        border: bgColor == Colors.grey[100]!
            ? Border.all(color: Colors.grey.shade300, width: 1)
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: textColor),
          SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
