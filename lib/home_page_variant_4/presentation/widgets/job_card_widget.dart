import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/app_export.dart';

class JobCardWidget extends StatelessWidget {
  final Map<String, dynamic> jobData;
  final VoidCallback? onTap;
  final VoidCallback? onBookmark;
  final VoidCallback? onApply;
  final VoidCallback? onShare;
  final bool isBookmarked;

  const JobCardWidget({
    super.key,
    required this.jobData,
    this.onTap,
    this.onBookmark,
    this.onApply,
    this.onShare,
    this.isBookmarked = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            onTap?.call();
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, theme),
                SizedBox(height: 2.h),
                _buildJobTitle(theme),
                SizedBox(height: 1.h),
                _buildCompanyInfo(theme),
                SizedBox(height: 2.h),
                _buildJobDetails(theme),
                SizedBox(height: 2.h),
                _buildActionButtons(context, theme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme) {
    return Row(
      children: [
        Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(11),
            child: CustomImageWidget(
              imageUrl:
                  (jobData['company'] as Map<String, dynamic>?)?['logo']
                      as String? ??
                  'https://via.placeholder.com/150x150/2563EB/FFFFFF?text=C',
              width: 12.w,
              height: 12.w,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const Spacer(),
        Row(
          children: [
            Text(
              _formatTimeAgo(jobData['posted_date'] as String? ?? ''),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(width: 2.w),
            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                onBookmark?.call();
              },
              child: Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: isBookmarked
                      ? theme.colorScheme.primary.withValues(alpha: 0.1)
                      : theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isBookmarked
                        ? theme.colorScheme.primary.withValues(alpha: 0.3)
                        : theme.colorScheme.outline.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: CustomIconWidget(
                  iconName: isBookmarked ? 'bookmark' : 'bookmark_outline',
                  color: isBookmarked
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildJobTitle(ThemeData theme) {
    return Text(
      jobData['title'] as String? ?? 'Job Title',
      style: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w600,
        color: theme.colorScheme.onSurface,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildCompanyInfo(ThemeData theme) {
    final company = jobData['company'] as Map<String, dynamic>?;

    return Row(
      children: [
        Expanded(
          child: Text(
            company?['name'] as String? ?? 'Company Name',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(width: 2.w),
        CustomIconWidget(
          iconName: 'location_on_outlined',
          color: theme.colorScheme.onSurfaceVariant,
          size: 16,
        ),
        SizedBox(width: 1.w),
        Flexible(
          child: Text(
            jobData['location'] as String? ?? 'Location',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildJobDetails(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: _buildDetailChip(
            theme,
            jobData['employment_type'] as String? ?? 'Full-time',
            theme.colorScheme.primary,
          ),
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: _buildDetailChip(
            theme,
            jobData['experience_level'] as String? ?? 'Mid-level',
            AppTheme.successLight,
          ),
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: _buildDetailChip(
            theme,
            _formatSalary(jobData['salary_range'] as Map<String, dynamic>?),
            AppTheme.warningLight,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailChip(ThemeData theme, String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Text(
        text,
        style: theme.textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, ThemeData theme) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              onApply?.call();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 1.5.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Apply Now',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              onShare?.call();
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.colorScheme.primary,
              padding: EdgeInsets.symmetric(vertical: 1.5.h),
              side: BorderSide(color: theme.colorScheme.primary, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: CustomIconWidget(
              iconName: 'share_outlined',
              color: theme.colorScheme.primary,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  String _formatTimeAgo(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else {
        return '${difference.inMinutes}m ago';
      }
    } catch (e) {
      return 'Recently';
    }
  }

  String _formatSalary(Map<String, dynamic>? salaryRange) {
    if (salaryRange == null) return '\$50K-70K';

    final min = salaryRange['min'] as num? ?? 50000;
    final max = salaryRange['max'] as num? ?? 70000;
    final currency = salaryRange['currency'] as String? ?? 'USD';

    return '\$${(min / 1000).toInt()}K-${(max / 1000).toInt()}K';
  }
}
