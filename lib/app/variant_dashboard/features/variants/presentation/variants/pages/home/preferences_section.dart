import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/data/models/preferences/model.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/preferences/providers/preferences_config_provider.dart';
import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/variants/pages/home/home_page_variant1.dart';
import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/variants/pages/home/provider/home_screen_provider.dart';
import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/variants/pages/home/widgets/preference_chip.dart';

import '../../../../../../../udaan_saarathi/features/domain/entities/preferences/entity.dart';

class PreferencesSection extends ConsumerWidget {
  // Changed to ConsumerWidget
  const PreferencesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Added WidgetRef ref
    final preferences = ref
        .watch(jobDashboardDataProvider)
        .preferences; // Access data via ref

  final apiPreferences = ref.watch(userPreferencesProvider);
  
    return Padding(
      padding: const EdgeInsets.all(24.0),
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
                  color: Color(0xFF2D3748),
                ),
              ),
              TextButton(
                onPressed: () => _showPreferencesModal(context),
                child: Text(
                  'Add',
                  style: TextStyle(
                    color: Color(0xFF4F7DF9),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Builder(
            builder: (context) {

return apiPreferences.when(
    data: (data) {
      return  Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: 
                      
                    
              
                      
                      data
                          .map<Widget>((pref) => _buildPreferenceChip(pref))
                          .toList(),
                    );
    },
    error: (error, stackTrace) {
      return _buildEmptyPreferences(context);
    },
    loading: () {
      return _buildEmptyPreferences(context);
    },
  );
              
           
                  
                  
                  
                 
            }
          ),
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
              backgroundColor: Color(0xFF4F7DF9),
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

class PreferencesModal extends ConsumerStatefulWidget {
  const PreferencesModal({super.key});
  // Changed to ConsumerStatefulWidget
  @override
  _PreferencesModalState createState() => _PreferencesModalState();
}

class _PreferencesModalState extends ConsumerState<PreferencesModal> {
  // Changed to ConsumerState
  final TextEditingController _controller = TextEditingController();
  final List<String> _availableTitles = [
    'Construction Worker',
    'Electrician',
    'Plumber',
    'Welder',
    'Driver',
    'Heavy Vehicle Operator',
    'Mason',
    'Carpenter',
    'Painter',
    'Cleaner',
    'Cook',
    'Waiter',
    'Security Guard',
    'Gardener',
    'Helper / General Labor',
    'Housekeeping Staff',
    'Mechanic',
    'AC Technician',
    'Factory Worker',
    'Store Keeper',
    'Delivery Boy',
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Access dashboardData using ref.watch
    final dashboardData = ref.watch(jobDashboardDataProvider);
    final preferences = dashboardData.preferences;

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Job Preferences',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close_rounded),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Select your preferred job titles in order of priority',
            style: TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView(
              children: [
                if (preferences.isNotEmpty) ...[
                  Text(
                    'Your Preferences (in priority order)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF4B5563),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...preferences.map<Widget>(
                    (pref) => _buildPreferenceItem(pref),
                  ),
                  const SizedBox(height: 24),
                ],
                Text(
                  'Available Job Titles',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4B5563),
                  ),
                ),
                const SizedBox(height: 12),
                ..._availableTitles
                    .where(
                      (title) =>
                          !preferences.any((pref) => pref.title == title),
                    )
                    .map<Widget>((title) => _buildAvailableTitleItem(title)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferenceItem(CandidatePreference pref) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4F7DF9), Color(0xFF6C5CE7)],
            ),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              pref.priority.toString(),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ),
        title: Text(
          pref.title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Color(0xFF2D3748),
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.remove_circle_outline, color: Colors.red),
          // Call method on notifier via ref.read
          onPressed: () =>
              ref.read(jobDashboardDataProvider).removePreference(pref.title),
        ),
        tileColor: Color(0xFFF7FAFC),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildAvailableTitleItem(String title) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(Icons.add_circle_outline, color: Color(0xFF4F7DF9)),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Color(0xFF2D3748),
          ),
        ),
        // Call method on notifier via ref.read
        onTap: () => ref.read(jobDashboardDataProvider).addPreference(title),
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Color(0xFFE2E8F0)),
        ),
      ),
    );
  }
}
