import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:variant_dashboard/features/variants/presentation/variants/pages/home/home_page_variant1.dart';
import 'package:variant_dashboard/features/variants/presentation/variants/pages/home/widgets/preference_chip.dart';

class JobPostingCard extends StatefulWidget {
  final JobPosting posting;

  const JobPostingCard({super.key, required this.posting});

  @override
  State<JobPostingCard> createState() => _JobPostingCardState();
}

class _JobPostingCardState extends State<JobPostingCard> {
  bool _isHorizontalView = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PreferenceChip(
              preferenceText: widget.posting.preferenceText,
              isPriorityReq: false,
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF4F7DF9), Color(0xFF6C5CE7)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.business_center_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.posting.postingTitle,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3748),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        '${widget.posting.employer} via ${widget.posting.agency}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF718096),
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              children: <Widget>[
                _buildInfoChip(
                  Icons.location_on_rounded,
                  '${widget.posting.city}, ${widget.posting.country}',
                ),
                const SizedBox(width: 12.0),
                _buildInfoChip(
                  Icons.work_history_rounded,
                  widget.posting.contractTerms['type'] ?? 'Contract',
                ),
              ],
            ),
            const SizedBox(height: 16.0),

            // Positions Header with Toggle
            Row(
              children: [
                Text(
                  'Available Positions (${widget.posting.positions.length})',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),
                Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFF7FAFC),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildToggleButton(
                        icon: Icons.list_rounded,
                        isSelected: !_isHorizontalView,
                        onTap: () => setState(() => _isHorizontalView = false),
                      ),
                      _buildToggleButton(
                        icon: Icons.view_carousel_rounded,
                        isSelected: _isHorizontalView,
                        onTap: () => setState(() => _isHorizontalView = true),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12.0),

            // Positions Display
            _isHorizontalView
                ? _buildHorizontalPositionsView()
                : _buildVerticalPositionsView(),

            const SizedBox(height: 16.0),
            Row(
              children: [
                Icon(
                  Icons.schedule_rounded,
                  size: 16,
                  color: Color(0xFF718096),
                ),
                const SizedBox(width: 4),
                Text(
                  'Posted ${_formatDate(widget.posting.postedDate)}',
                  style: TextStyle(fontSize: 12, color: Color(0xFF718096)),
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: widget.posting.isActive
                        ? Colors.green.withOpacity(0.1)
                        : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.posting.isActive ? 'Active' : 'Closed',
                    style: TextStyle(
                      fontSize: 12,
                      color: widget.posting.isActive
                          ? Colors.green
                          : Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20.0),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xFF4F7DF9).withOpacity(0.3),
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextButton(
                      onPressed: () => _showJobDetails(context, widget.posting),
                      child: Text(
                        'View Details',
                        style: TextStyle(
                          color: Color(0xFF4F7DF9),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF4F7DF9), Color(0xFF6C5CE7)],
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextButton(
                      onPressed: widget.posting.isActive
                          ? () => _applyToJob(context, widget.posting)
                          : null,
                      child: Text(
                        'Apply Now',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton({
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF4F7DF9) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          icon,
          size: 16,
          color: isSelected ? Colors.white : Color(0xFF718096),
        ),
      ),
    );
  }

  Widget _buildVerticalPositionsView() {
    return Column(
      children: [
        ...widget.posting.positions
            .take(2)
            .map<Widget>((position) => _buildPositionRow(position)),
        if (widget.posting.positions.length > 2)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              '+ ${widget.posting.positions.length - 2} more positions',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF4F7DF9),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildHorizontalPositionsView() {
    return SizedBox(
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.posting.positions.length,
        itemBuilder: (context, index) {
          return Container(
            width: 220,
            margin: EdgeInsets.only(right: 12),
            child: _buildHorizontalPositionCard(
              widget.posting.positions[index],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHorizontalPositionCard(JobPosition position) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      position.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3748),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (position.convertedSalary != null) ...[
                      const SizedBox(height: 4),
                      // Text(
                      //   position.convertedSalary!,
                      //   style: TextStyle(
                      //     fontSize: 13,
                      //     color: Color(0xFF4F7DF9),
                      //     fontWeight: FontWeight.w600,
                      //   ),
                      // ),
                      Text(
                        position.baseSalary!,
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF718096),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: Color(0xFF9CA3AF),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Color(0xFFF7FAFC),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Color(0xFF718096)),
          const SizedBox(width: 6.0),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF718096),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPositionRow(JobPosition position) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  position.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),
                if (position.convertedSalary != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    '${position.convertedSalary} (${position.baseSalary})',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF4F7DF9),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios_rounded,
            size: 16,
            color: Color(0xFF9CA3AF),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) return 'today';
    if (difference == 1) return '1 day ago';
    if (difference < 7) return '$difference days ago';
    if (difference < 30) return '${(difference / 7).floor()} weeks ago';
    return DateFormat.yMMMd().format(date);
  }

  void _showJobDetails(BuildContext context, JobPosting posting) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => JobDetailsModal(posting: posting),
    );
  }

  void _applyToJob(BuildContext context, JobPosting posting) {
    showDialog(
      context: context,
      builder: (context) => ApplyJobDialog(posting: posting),
    );
  }
}
