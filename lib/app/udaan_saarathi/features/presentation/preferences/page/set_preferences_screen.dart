import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/data/repositories/preferences/repository_impl_fake.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/preferences/widgets/widgets.dart';
import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/variants/pages/set_preferences/set_preferences_3.dart';

final currentStepProvider = StateProvider((ref) => 0);

class SetPreferenceScreen extends StatefulWidget {
  const SetPreferenceScreen({super.key});

  @override
  _SetPreferenceScreenState createState() => _SetPreferenceScreenState();
}

class _SetPreferenceScreenState extends State<SetPreferenceScreen> {
  int currentStep = 0;

  // Ordered job titles with priorities
  List<JobTitleWithPriority> selectedJobTitles = [];

  // Other preferences
  List<String> selectedCountries = [];
  List<String> selectedIndustries = [];
  List<String> selectedWorkLocations = [];
  Map<String, double> salaryRange = {'min': 800, 'max': 3000}; // USD monthly
  List<String> selectedWorkCulture = [];
  List<String> selectedAgencies = [];
  String selectedCompanySize = '';
  List<String> selectedShiftPreferences = [];
  String selectedExperienceLevel = '';
  bool trainingSupport = false;
  String contractDuration = '';
  List<String> selectedBenefits = [];

  // Data sources
  final List<JobTitle> availableJobTitles = [
    JobTitle(
      id: 1,
      title: 'Waiter/Waitress',
      category: 'Hospitality',
      isActive: true,
    ),
    JobTitle(id: 2, title: 'Chef', category: 'Hospitality', isActive: true),
    JobTitle(id: 3, title: 'Cook', category: 'Hospitality', isActive: true),
    JobTitle(
      id: 4,
      title: 'Kitchen Helper',
      category: 'Hospitality',
      isActive: true,
    ),
    JobTitle(id: 5, title: 'Barista', category: 'Hospitality', isActive: true),
    JobTitle(id: 6, title: 'Plumber', category: 'Construction', isActive: true),
    JobTitle(
      id: 7,
      title: 'Electrician',
      category: 'Construction',
      isActive: true,
    ),
    JobTitle(
      id: 8,
      title: 'Construction Worker',
      category: 'Construction',
      isActive: true,
    ),
    JobTitle(id: 9, title: 'Painter', category: 'Construction', isActive: true),
    JobTitle(
      id: 10,
      title: 'Driver',
      category: 'Transportation',
      isActive: true,
    ),
    JobTitle(
      id: 11,
      title: 'Delivery Driver',
      category: 'Transportation',
      isActive: true,
    ),
    JobTitle(
      id: 12,
      title: 'Taxi Driver',
      category: 'Transportation',
      isActive: true,
    ),
    JobTitle(
      id: 13,
      title: 'Gardener',
      category: 'Maintenance',
      isActive: true,
    ),
    JobTitle(id: 14, title: 'Cleaner', category: 'Maintenance', isActive: true),
    JobTitle(
      id: 15,
      title: 'Security Guard',
      category: 'Security',
      isActive: true,
    ),
    JobTitle(
      id: 16,
      title: 'Housekeeping',
      category: 'Hospitality',
      isActive: true,
    ),
    JobTitle(id: 17, title: 'Mechanic', category: 'Automotive', isActive: true),
    JobTitle(id: 18, title: 'Welder', category: 'Construction', isActive: true),
    JobTitle(id: 19, title: 'Salesperson', category: 'Retail', isActive: true),
    JobTitle(
      id: 20,
      title: 'Office Assistant',
      category: 'Administration',
      isActive: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildProgressIndicator(),
          Expanded(child: _buildStepContent()),
          _buildBottomNavigation(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      title: Text(
        'Set Your Job Preferences',
        style: TextStyle(
          color: Color(0xFF1E293B),
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: Color(0xFF64748B)),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        TextButton(
          onPressed: _skipToEnd,
          child: Text(
            'Skip',
            style: TextStyle(color: Color(0xFF64748B), fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: List.generate(6, (index) {
              bool isActive = index <= currentStep;
              bool isCompleted = index < currentStep;

              return Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 2),
                  height: 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: isCompleted
                        ? Color(0xFF10B981)
                        : isActive
                            ? Color(0xFF1E88E5)
                            : Color(0xFFE2E8F0),
                  ),
                ),
              );
            }),
          ),
          SizedBox(height: 12),
          Text(
            '${currentStep + 1} of 6 - ${_getStepTitle(currentStep)}',
            style: TextStyle(
              color: Color(0xFF64748B),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _getStepTitle(int step) {
    switch (step) {
      case 0:
        return 'Job Titles (Priority Order)';
      case 1:
        return 'Countries & Locations';
      case 2:
        return 'Salary & Work Preferences';
      case 3:
        return 'Company & Culture';
      case 4:
        return 'Contract & Benefits';
      case 5:
        return 'Review & Confirm';
      default:
        return '';
    }
  }

  Widget _buildStepContent() {
    switch (currentStep) {
      case 0:
        return _buildJobTitlesStep();
      case 1:
        return _buildCountriesStep();
      case 2:
        return _buildSalaryWorkStep();
      case 3:
        return _buildCompanyCultureStep();
      case 4:
        return _buildContractBenefitsStep();
      case 5:
        return _buildReviewStep();
      default:
        return Container();
    }
  }

  Widget _buildJobTitlesStep() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StepHeader(
            title: 'Choose Your Preferred Job Titles',
            subtitle:
                'Select and prioritize job titles. Your top choice appears first.',
            icon: Icons.work_outline,
            color: Color(0xFF3B82F6),
          ),

          SizedBox(height: 24),

          // Selected Job Titles (Ordered by Priority)
          if (selectedJobTitles.isNotEmpty) ...[
            Text(
              'Your Preferences (Priority Order)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
            SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ReorderableListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                onReorder: _reorderJobTitles,
                children: selectedJobTitles.asMap().entries.map((entry) {
                  int index = entry.key;
                  JobTitleWithPriority jobTitle = entry.value;

                  return _buildSelectedJobTitleCard(
                    jobTitle,
                    index,
                    key: ValueKey(jobTitle.jobTitle.id),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 24),
          ],

          // Available Job Titles by Category
          Text(
            'Available Job Titles',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
          SizedBox(height: 12),

          ..._buildJobTitlesByCategory(),
        ],
      ),
    );
  }

  Widget _buildSelectedJobTitleCard(
    JobTitleWithPriority jobTitle,
    int index, {
    required Key key,
  }) {
    return Container(
      key: key,
      margin: EdgeInsets.only(bottom: 1),
      decoration: BoxDecoration(
        color: Color(0xFFF1F5F9),
        border: Border(left: BorderSide(color: Color(0xFF1E88E5), width: 4)),
      ),
      child: ListTile(
        leading: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Color(0xFF1E88E5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Text(
              '${index + 1}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        title: Text(
          jobTitle.jobTitle.title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
        ),
        subtitle: Text(
          jobTitle.jobTitle.category,
          style: TextStyle(color: Color(0xFF64748B), fontSize: 12),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.drag_handle, color: Color(0xFF94A3B8)),
            SizedBox(width: 8),
            GestureDetector(
              onTap: () => _removeJobTitle(jobTitle),
              child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(Icons.close, size: 16, color: Color(0xFFEF4444)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildJobTitlesByCategory() {
    Map<String, List<JobTitle>> categorizedJobs = {};

    for (JobTitle job in availableJobTitles) {
      if (!job.isActive) continue;
      if (selectedJobTitles.any((selected) => selected.jobTitle.id == job.id))
        continue;

      if (!categorizedJobs.containsKey(job.category)) {
        categorizedJobs[job.category] = [];
      }
      categorizedJobs[job.category]!.add(job);
    }

    return categorizedJobs.entries.map((entry) {
      String category = entry.key;
      List<JobTitle> jobs = entry.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 12),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
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
                Text(
                  category,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF475569),
                  ),
                ),
                SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: jobs.map((job) => _buildJobTitleChip(job)).toList(),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
        ],
      );
    }).toList();
  }

  Widget _buildJobTitleChip(JobTitle job) {
    return GestureDetector(
      onTap: () => _addJobTitle(job),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Color(0xFFE2E8F0), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_circle_outline, size: 16, color: Color(0xFF1E88E5)),
            SizedBox(width: 6),
            Text(
              job.title,
              style: TextStyle(
                color: Color(0xFF475569),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountriesStep() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StepHeader(
            title: 'Choose Your Target Countries',
            subtitle: 'Select Gulf countries where you want to work.',
            icon: Icons.public,
            color: Color(0xFF059669),
          ),
          SizedBox(height: 24),
          MultiSelectSection(
            title: 'Gulf Countries',
            options: gulfCountries,
            selected: selectedCountries,
            onToggle: (country) => _toggleSelection(selectedCountries, country),
            color: Color(0xFF059669),
          ),
          SizedBox(height: 24),
          MultiSelectSection(
            title: 'Preferred Work Locations',
            options: workLocations,
            selected: selectedWorkLocations,
            onToggle: (location) =>
                _toggleSelection(selectedWorkLocations, location),
            color: Color(0xFF0891B2),
          ),
        ],
      ),
    );
  }

  Widget _buildSalaryWorkStep() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StepHeader(
            title: 'Salary & Work Preferences',
            subtitle: 'Set your salary expectations and work preferences.',
            icon: Icons.attach_money,
            color: Color(0xFFDC2626),
          ),

          SizedBox(height: 24),

          // Salary Range
          _buildSalaryRangeSection(),

          SizedBox(height: 24),

          MultiSelectSection(
            title: 'Industries',
            options: industries,
            selected: selectedIndustries,
            onToggle: (industry) =>
                _toggleSelection(selectedIndustries, industry),
            color: Color(0xFF7C3AED),
          ),

          SizedBox(height: 24),

          SingleSelectSection(
            title: 'Experience Level',
            options: experienceLevels,
            selected: selectedExperienceLevel,
            onSelect: (level) =>
                setState(() => selectedExperienceLevel = level),
            color: Color(0xFFEA580C),
          ),

          SizedBox(height: 24),

          MultiSelectSection(
            title: 'Shift Preferences',
            options: shiftPreferences,
            selected: selectedShiftPreferences,
            onToggle: (shift) =>
                _toggleSelection(selectedShiftPreferences, shift),
            color: Color(0xFF0891B2),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyCultureStep() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StepHeader(
            title: 'Company & Culture Preferences',
            subtitle:
                'Choose your preferred work environment and company type.',
            icon: Icons.business,
            color: Color(0xFF7C2D12),
          ),
          SizedBox(height: 24),
          SingleSelectSection(
            title: 'Company Size',
            options: companySizes,
            selected: selectedCompanySize,
            onSelect: (size) => setState(() => selectedCompanySize = size),
            color: Color(0xFF7C2D12),
          ),
          SizedBox(height: 24),
          MultiSelectSection(
            title: 'Work Culture',
            options: workCulture,
            selected: selectedWorkCulture,
            onToggle: (culture) =>
                _toggleSelection(selectedWorkCulture, culture),
            color: Color(0xFF059669),
          ),
          SizedBox(height: 24),
          MultiSelectSection(
            title: 'Preferred Agencies/Employers',
            options: agencies,
            selected: selectedAgencies,
            onToggle: (agency) => _toggleSelection(selectedAgencies, agency),
            color: Color(0xFF0891B2),
          ),
          SizedBox(height: 24),
          _buildTrainingSupportSection(),
        ],
      ),
    );
  }

  Widget _buildContractBenefitsStep() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StepHeader(
            title: 'Contract & Benefits',
            subtitle: 'Select your contract duration and desired benefits.',
            icon: Icons.description,
            color: Color(0xFF7C3AED),
          ),
          SizedBox(height: 24),
          SingleSelectSection(
            title: 'Contract Duration',
            options: contractDurations,
            selected: contractDuration,
            onSelect: (duration) => setState(() => contractDuration = duration),
            color: Color(0xFF7C3AED),
          ),
          SizedBox(height: 24),
          MultiSelectSection(
            title: 'Desired Work Benefits',
            options: workBenefits,
            selected: selectedBenefits,
            onToggle: (benefit) => _toggleSelection(selectedBenefits, benefit),
            color: Color(0xFF059669),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewStep() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StepHeader(
            title: 'Review Your Preferences',
            subtitle: 'Review and confirm your job preferences before saving.',
            icon: Icons.check_circle_outline,
            color: Color(0xFF059669),
          ),

          SizedBox(height: 24),

          // Job Titles Summary
          if (selectedJobTitles.isNotEmpty)
            _buildReviewSection(
              'Job Titles (Priority Order)',
              selectedJobTitles
                  .map(
                    (jt) =>
                        '${selectedJobTitles.indexOf(jt) + 1}. ${jt.jobTitle.title}',
                  )
                  .toList(),
              Color(0xFF3B82F6),
            ),

          // Countries Summary
          if (selectedCountries.isNotEmpty)
            _buildReviewSection(
              'Target Countries',
              selectedCountries,
              Color(0xFF059669),
            ),

          // Salary Summary
          _buildReviewSection(
              'Salary Range',
              [
                'USD ${salaryRange['min']!.round()} - ${salaryRange['max']!.round()} per month',
              ],
              Color(0xFFDC2626)),

          // Other preferences summaries...
          if (selectedIndustries.isNotEmpty)
            _buildReviewSection(
              'Industries',
              selectedIndustries,
              Color(0xFF7C3AED),
            ),

          if (selectedExperienceLevel.isNotEmpty)
            _buildReviewSection(
                'Experience Level',
                [
                  selectedExperienceLevel,
                ],
                Color(0xFFEA580C)),
        ],
      ),
    );
  }

  Widget _buildSalaryRangeSection() {
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
          Row(
            children: [
              Icon(Icons.attach_money, color: Color(0xFFDC2626), size: 24),
              SizedBox(width: 8),
              Text(
                'Expected Monthly Salary (USD)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),

          // Salary Display
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Color(0xFFDC2626).withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Minimum',
                      style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                    ),
                    Text(
                      'USD ${salaryRange['min']!.round()}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFDC2626),
                      ),
                    ),
                  ],
                ),
                Container(width: 1, height: 40, color: Color(0xFFE2E8F0)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Maximum',
                      style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                    ),
                    Text(
                      'USD ${salaryRange['max']!.round()}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFDC2626),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 20),

          // Salary Range Slider
          RangeSlider(
            values: RangeValues(salaryRange['min']!, salaryRange['max']!),
            min: 200,
            max: 5000,
            divisions: 48,
            activeColor: Color(0xFFDC2626),
            inactiveColor: Color(0xFFE2E8F0),
            labels: RangeLabels(
              'USD ${salaryRange['min']!.round()}',
              'USD ${salaryRange['max']!.round()}',
            ),
            onChanged: (values) {
              setState(() {
                salaryRange['min'] = values.start;
                salaryRange['max'] = values.end;
              });
            },
          ),

          // Quick Select Buttons
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildQuickSalaryButton('Entry Level', 400, 800)),
              SizedBox(width: 8),
              Expanded(child: _buildQuickSalaryButton('Mid Level', 800, 1500)),
              SizedBox(width: 8),
              Expanded(child: _buildQuickSalaryButton('Senior', 1500, 3000)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickSalaryButton(String label, double min, double max) {
    bool isSelected = salaryRange['min'] == min && salaryRange['max'] == max;

    return GestureDetector(
      onTap: () {
        setState(() {
          salaryRange['min'] = min;
          salaryRange['max'] = max;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Color(0xFFDC2626).withOpacity(0.1)
              : Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Color(0xFFDC2626) : Color(0xFFE2E8F0),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isSelected ? Color(0xFFDC2626) : Color(0xFF64748B),
              ),
            ),
            Text(
              '\${min.round()}-${max.round()}',
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? Color(0xFFDC2626) : Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrainingSupportSection() {
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
          Row(
            children: [
              Icon(Icons.school, color: Color(0xFF059669), size: 24),
              SizedBox(width: 8),
              Text(
                'Training Support Required',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              setState(() {
                trainingSupport = !trainingSupport;
              });
            },
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: trainingSupport
                    ? Color(0xFF059669).withOpacity(0.1)
                    : Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color:
                      trainingSupport ? Color(0xFF059669) : Color(0xFFE2E8F0),
                  width: trainingSupport ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: trainingSupport
                            ? Color(0xFF059669)
                            : Color(0xFFCBD5E1),
                        width: 2,
                      ),
                      color: trainingSupport
                          ? Color(0xFF059669)
                          : Colors.transparent,
                    ),
                    child: trainingSupport
                        ? Icon(Icons.check, size: 16, color: Colors.white)
                        : null,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Yes, I need training support',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: trainingSupport
                                ? Color(0xFF059669)
                                : Color(0xFF475569),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'I would like companies that provide job training and skill development',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewSection(String title, List<String> items, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.05),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 20,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: items
                  .map(
                    (item) => Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle, size: 16, color: color),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              item,
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF475569),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _previousStep,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Color(0xFF1E88E5)),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Previous',
                  style: TextStyle(
                    color: Color(0xFF1E88E5),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          if (currentStep > 0) SizedBox(width: 16),
          Expanded(
            flex: currentStep == 0 ? 1 : 2,
            child: ElevatedButton(
              onPressed: _isStepValid() ? _nextStep : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1E88E5),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                disabledBackgroundColor: Color(0xFFE2E8F0),
              ),
              child: Text(
                currentStep == 5 ? 'Save Preferences' : 'Next',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Job Title Management Methods
  void _addJobTitle(JobTitle jobTitle) {
    setState(() {
      // Check if already exists
      int existingIndex = selectedJobTitles.indexWhere(
        (jt) => jt.jobTitle.id == jobTitle.id,
      );

      if (existingIndex != -1) {
        // Move to top (re-prioritize)
        JobTitleWithPriority existing = selectedJobTitles.removeAt(
          existingIndex,
        );
        selectedJobTitles.insert(0, existing);
      } else {
        // Add new at top
        selectedJobTitles.insert(
          0,
          JobTitleWithPriority(jobTitle: jobTitle, priority: 0),
        );
      }

      // Reindex priorities
      _reindexPriorities();
    });

    HapticFeedback.lightImpact();
  }

  void _removeJobTitle(JobTitleWithPriority jobTitle) {
    setState(() {
      selectedJobTitles.remove(jobTitle);
      _reindexPriorities();
    });

    HapticFeedback.lightImpact();
  }

  void _reorderJobTitles(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }

      final JobTitleWithPriority item = selectedJobTitles.removeAt(oldIndex);
      selectedJobTitles.insert(newIndex, item);

      _reindexPriorities();
    });

    HapticFeedback.mediumImpact();
  }

  void _reindexPriorities() {
    for (int i = 0; i < selectedJobTitles.length; i++) {
      selectedJobTitles[i].priority = i;
    }
  }

  // Utility Methods
  void _toggleSelection(List<String> list, String item) {
    setState(() {
      if (list.contains(item)) {
        list.remove(item);
      } else {
        list.add(item);
      }
    });

    HapticFeedback.selectionClick();
  }

  bool _isStepValid() {
    switch (currentStep) {
      case 0:
        return selectedJobTitles.isNotEmpty;
      case 1:
        return selectedCountries.isNotEmpty;
      case 2:
        return selectedIndustries.isNotEmpty &&
            selectedExperienceLevel.isNotEmpty;
      case 3:
        return selectedCompanySize.isNotEmpty;
      case 4:
        return contractDuration.isNotEmpty;
      case 5:
        return true;
      default:
        return false;
    }
  }

  void _nextStep() {
    if (currentStep < 5) {
      setState(() {
        currentStep++;
      });
    } else {
      _savePreferences();
    }
  }

  void _previousStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
    }
  }

  void _skipToEnd() {
    setState(() {
      currentStep = 5;
    });
  }

  void _savePreferences() {
    // Validate job titles against active JobTitles
    List<JobTitleWithPriority> validatedTitles =
        selectedJobTitles.where((jt) => jt.jobTitle.isActive).toList();

    // Simulate API call to save preferences
    Map<String, dynamic> preferences = {
      'jobTitles': validatedTitles
          .map(
            (jt) => {
              'id': jt.jobTitle.id,
              'title': jt.jobTitle.title,
              'priority': jt.priority,
            },
          )
          .toList(),
      'countries': selectedCountries,
      'industries': selectedIndustries,
      'workLocations': selectedWorkLocations,
      'salaryRange': salaryRange,
      'workCulture': selectedWorkCulture,
      'agencies': selectedAgencies,
      'companySize': selectedCompanySize,
      'shiftPreferences': selectedShiftPreferences,
      'experienceLevel': selectedExperienceLevel,
      'trainingSupport': trainingSupport,
      'contractDuration': contractDuration,
      'benefits': selectedBenefits,
    };

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12),
            Text('Preferences saved successfully!'),
          ],
        ),
        backgroundColor: Color(0xFF059669),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );

    // Navigate back or to next screen
    // Navigator.pop(context, preferences);
  }
}
