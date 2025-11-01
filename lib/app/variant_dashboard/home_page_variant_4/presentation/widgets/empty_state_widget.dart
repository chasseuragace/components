import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:variant_dashboard/app/variant_dashboard/home_page_variant_4/widgets/custom_icon_widget.dart';
import 'package:variant_dashboard/app/variant_dashboard/home_page_variant_4/widgets/custom_imge_widget.dart';

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonText;
  final VoidCallback? onButtonPressed;
  final String? illustrationUrl;

  const EmptyStateWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    this.onButtonPressed,
    this.illustrationUrl,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(6.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60.w,
            height: 30.h,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: illustrationUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CustomImageWidget(
                      imageUrl: illustrationUrl!,
                      width: 60.w,
                      height: 30.h,
                      fit: BoxFit.cover,
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.2,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: CustomIconWidget(
                          iconName: 'work_outline',
                          color: theme.colorScheme.primary,
                          size: 48,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Container(
                        width: 30.w,
                        height: 1.h,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.3,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Container(
                        width: 20.w,
                        height: 1.h,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.2,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
          ),
          SizedBox(height: 4.h),
          Text(
            title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.h),
          Text(
            subtitle,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onButtonPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
              ),
              child: Text(
                buttonText,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
