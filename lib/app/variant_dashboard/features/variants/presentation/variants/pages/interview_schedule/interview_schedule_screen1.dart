import 'package:flutter/material.dart';
import 'package:variant_dashboard/app/variant_dashboard/features/variants/domain/entities/interview_schedule.dart';

class InterviewScheduleScreen1 extends StatefulWidget {
  const InterviewScheduleScreen1({super.key});

  @override
  _InterviewScheduleScreen1State createState() =>
      _InterviewScheduleScreen1State();
}

class _InterviewScheduleScreen1State extends State<InterviewScheduleScreen1> {
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
        statusColor: Colors.green.shade600,
        statusIcon: Icons.check_circle_outline,
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
        statusColor: Colors.blue.shade600,
        statusIcon: Icons.schedule,
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
        statusColor: Colors.grey.shade600,
        statusIcon: Icons.pending,
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
        statusColor: Colors.orange.shade600,
        statusIcon: Icons.update,
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
        statusColor: Colors.green.shade600,
        statusIcon: Icons.check_circle_outline,
      ),
      InterviewSchedule(
        jobTitle: "Cleaner",
        companyName: "Saudi Facilities Group",
        companyLogo: "SF",
        interviewType: "Phone Call",
        interviewRound: "Initial Screening",
        dateTime: DateTime.now().add(const Duration(days: 2)),
        duration: "30m",
        location: "Phone Interview",
        interviewer: "Huda Saleh",
        interviewerRole: "HR Officer",
        status: "Scheduled",
        priority: "Medium",
        salaryRange: "SAR 1,200 - SAR 1,600",
        statusColor: Colors.blue.shade600,
        statusIcon: Icons.phone,
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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Interview Schedule',
          style: TextStyle(
            color: Colors.grey[800],
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Search Section
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _filterInterviews,
                style: TextStyle(color: Colors.grey[800], fontSize: 15),
                decoration: InputDecoration(
                  hintText: 'Search interviews',
                  hintStyle: TextStyle(color: Colors.grey[500], fontSize: 15),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey[500],
                    size: 20,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
            ),
          ),

          // Interview List
          Expanded(
            child: _filteredInterviews.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    itemCount: _filteredInterviews.length,
                    itemBuilder: (context, index) {
                      return MinimalInterviewCard(
                        interview: _filteredInterviews[index],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 48, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            'No interviews found',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class MinimalInterviewCard extends StatelessWidget {
  final InterviewSchedule interview;

  const MinimalInterviewCard({super.key, required this.interview});

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
        return Colors.blue.shade600;
      case 'medium':
        return Colors.green.shade600;
      case 'low':
        return Colors.grey.shade500;
      default:
        return Colors.grey.shade500;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              children: [
                // Company Avatar
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Center(
                    child: Text(
                      interview.companyLogo,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
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
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        interview.companyName,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                // Status Badge
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: interview.statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
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
                          fontWeight: FontWeight.w500,
                          color: interview.statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),

            // Interview Details
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildDetailItem(
                          Icons.schedule,
                          _formatDateTime(interview.dateTime),
                        ),
                      ),
                      Container(width: 1, height: 20, color: Colors.grey[300]),
                      SizedBox(width: 16),
                      Expanded(
                        child: _buildDetailItem(
                          Icons.access_time,
                          interview.duration,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDetailItem(
                          Icons.videocam,
                          interview.interviewType,
                        ),
                      ),
                      Container(width: 1, height: 20, color: Colors.grey[300]),
                      SizedBox(width: 16),
                      Expanded(
                        child: _buildDetailItem(
                          Icons.layers,
                          interview.interviewRound,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),

            // Interviewer and Salary Row
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
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        interview.interviewer,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        interview.interviewerRole,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Salary Range',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      interview.salaryRange,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.green[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 16),

            // Priority and Actions Row
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getPriorityColor(
                      interview.priority,
                    ).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${interview.priority} Priority',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: _getPriorityColor(interview.priority),
                    ),
                  ),
                ),
                Spacer(),
                _buildActionButton(
                  'Reschedule',
                  Icons.schedule,
                  Colors.grey[600]!,
                ),
                SizedBox(width: 8),
                _buildActionButton('Join', Icons.videocam, Colors.blue[600]!),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
              fontWeight: FontWeight.w400,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(String text, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
