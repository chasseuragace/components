import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:variant_dashboard/app/variant_dashboard/home_page_variant_4/theme/app_theme.dart';
import 'package:variant_dashboard/app/variant_dashboard/home_page_variant_4/widgets/custom_icon_widget.dart';

class AnalyticsCardsWidget extends StatelessWidget {
  final int applicationsSent;
  final int profileViews;
  final int savedJobs;
  final double applicationsTrend;
  final double profileViewsTrend;
  final double savedJobsTrend;

  const AnalyticsCardsWidget({
    super.key,
    required this.applicationsSent,
    required this.profileViews,
    required this.savedJobs,
    required this.applicationsTrend,
    required this.profileViewsTrend,
    required this.savedJobsTrend,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Job Search Analytics',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildAnalyticsCard(
                  context,
                  'Applications Sent',
                  applicationsSent.toString(),
                  applicationsTrend,
                  theme.colorScheme.primary,
                  'work_outline',
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildAnalyticsCard(
                  context,
                  'Profile Views',
                  profileViews.toString(),
                  profileViewsTrend,
                  AppTheme.successLight,
                  'visibility_outlined',
                ),
              ),
            ],
          ),
          SizedBox(height: 3.w),
          _buildAnalyticsCard(
            context,
            'Saved Jobs',
            savedJobs.toString(),
            savedJobsTrend,
            AppTheme.warningLight,
            'bookmark_outline',
            isFullWidth: true,
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsCard(
    BuildContext context,
    String title,
    String value,
    double trend,
    Color color,
    String iconName, {
    bool isFullWidth = false,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: isFullWidth
          ? Row(
              children: [
                _buildIconContainer(color, iconName),
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        value,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildTrendIndicator(theme, trend),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildIconContainer(color, iconName),
                    _buildTrendIndicator(theme, trend),
                  ],
                ),
                SizedBox(height: 2.h),
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  value,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildIconContainer(Color color, String iconName) {
    return Container(
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: CustomIconWidget(iconName: iconName, color: color, size: 24),
    );
  }

  Widget _buildTrendIndicator(ThemeData theme, double trend) {
    final isPositive = trend >= 0;
    final trendColor = isPositive ? AppTheme.successLight : AppTheme.errorLight;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
      decoration: BoxDecoration(
        color: trendColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: isPositive ? 'trending_up' : 'trending_down',
            color: trendColor,
            size: 16,
          ),
          SizedBox(width: 1.w),
          Text(
            '${trend.abs().toStringAsFixed(1)}%',
            style: theme.textTheme.bodySmall?.copyWith(
              color: trendColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
