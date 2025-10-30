import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/colors/app_colors.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/data/models/preferences/model.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/preferences/providers/preferences_config_provider.dart';
import 'package:variant_dashboard/app/udaan_saarathi/utils/size_config.dart';
import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/variants/pages/home/preferences_modal.dart';
import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/variants/pages/home/provider/home_screen_provider.dart';
import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/variants/pages/home/widgets/preference_chip.dart';

import '../../../../../../../udaan_saarathi/features/domain/entities/preferences/entity.dart';


class PreferencesSection extends ConsumerWidget {
  // Changed to ConsumerWidget
  const PreferencesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Added WidgetRef ref
    final preferences =
        ref.watch(jobDashboardDataProvider).preferences; // Access data via ref

    final apiPreferences = ref.watch(userPreferencesProvider);

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: kHorizontalMargin, vertical: kVerticalMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Job Preferences',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () => _showPreferencesModal(context),
                child: Text(
                  'Add',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: kVerticalMargin),
          Builder(builder: (context) {
            return apiPreferences.when(
              data: (data) {
                final visibleItems =  data.take(5).toList();
                final remainingCount = data.length > 5 ? data.length - 5 : 0;
                
                return Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: [
                    ...visibleItems.map((pref) => _buildPreferenceChip(pref)),
                    if (remainingCount > 0 )
                    Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4F7DF9), Color(0xFF6C5CE7)],
          // colors: [AppColors.primaryColor, AppColors.primaryDarkColor],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
       
            Container(
            
              height: 20,
             
             
            ),
            const SizedBox(width: 8),
         
          Text(
            "+$remainingCount More items",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
                      ),
                  ],
                );
              },
              error: (error, stackTrace) {
                return _buildEmptyPreferences(context);
              },
              loading: () {
                return _buildEmptyPreferences(context);
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildEmptyPreferences(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Color(0xFFF7FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Icon(Icons.work_outline_rounded, size: 48, color: Color(0xFF9CA3AF)),
          const SizedBox(height: 16),
          Text(
            'No job preferences set',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4B5563),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your preferred job titles to get personalized recommendations',
            style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _showPreferencesModal(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Add Preferences'),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferenceChip(PreferencesEntity pref) {
    return PreferenceChip(
      preferencepriority: pref.priority.toString(),
      preferenceText: pref.title,
    );
  }

  void _showPreferencesModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => PreferencesModal(),
    );
  }
}
