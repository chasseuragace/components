import 'package:flutter/material.dart';

// Dummy model
class ManpowerModel {
  final String name;
  final String location;
  final String description;
  final List<String> trustFactors;
  final List<String> specializations;
  final int activeJobs;
  final int successRate;
  final bool verified;
  final String phone;
  final String email;
  final int views;

  ManpowerModel({
    required this.name,
    required this.location,
    required this.description,
    required this.trustFactors,
    required this.specializations,
    required this.activeJobs,
    required this.successRate,
    required this.verified,
    required this.phone,
    required this.email,
    required this.views,
  });

  String getInitials() {
    return name.isNotEmpty ? name[0].toUpperCase() : "?";
  }
}

// ------------------ LISTING PAGE ------------------
class AgencyListingScreen3 extends StatelessWidget {
  const AgencyListingScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    final agencies = [
      ManpowerModel(
        name: "Global Recruiters",
        location: "Dubai, UAE",
        description: "Specialized in hospitality and construction manpower.",
        trustFactors: ["Licensed", "ISO Certified", "Trusted"],
        specializations: ["Hospitality", "Construction", "Healthcare"],
        activeJobs: 23,
        successRate: 92,
        verified: true,
        phone: "+971 50 123 4567",
        email: "info@globalrecruiters.com",
        views: 1240,
      ),
      ManpowerModel(
        name: "Skyline Manpower",
        location: "Doha, Qatar",
        description: "Providing skilled and unskilled workforce for GCC.",
        trustFactors: ["MOI Approved", "High Retention"],
        specializations: ["Drivers", "Technicians", "Cleaners", "Security"],
        activeJobs: 18,
        successRate: 88,
        verified: false,
        phone: "+974 55 987 654",
        email: "contact@skyline.com",
        views: 850,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Manpower Agencies"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: Column(
        children: [
          // Search and Filter Row
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search agencies...",
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.filter_list, color: Colors.blue),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(24),
                        ),
                      ),
                      builder: (context) => const FilterSheet(),
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: agencies.length,
              itemBuilder: (context, index) {
                return ManpowerCard(agency: agencies[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------ CARD ------------------
class ManpowerCard extends StatelessWidget {
  final ManpowerModel agency;

  const ManpowerCard({super.key, required this.agency});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Avatar and Basic Info
          Row(
            children: [
              // Avatar
              Stack(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: [Colors.blue[400]!, Colors.purple[400]!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        agency.getInitials(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  if (agency.verified)
                    Positioned(
                      right: -2,
                      top: -2,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.blue[600],
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          size: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              // Agency Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          agency.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[900],
                          ),
                        ),
                        _ContactItem(
                          icon: Icons.visibility,
                          text: "${agency.views} views",
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 16,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          agency.location,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Description
          Text(
            agency.description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),

          // Trust Factors
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: agency.trustFactors
                .map((factor) => TrustBadge(trustFactor: factor))
                .toList(),
          ),
          const SizedBox(height: 16),

          // Specializations
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              ...agency.specializations.take(3).map((spec) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    spec,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }),
              if (agency.specializations.length > 3)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '+${agency.specializations.length - 3} more',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),

          // Stats and Action Row
          Row(
            children: [
              // Stats
              Expanded(
                child: Row(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.work, size: 16, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text(
                          '${agency.activeJobs} jobs',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Row(
                      children: [
                        Icon(
                          Icons.trending_up,
                          size: 16,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${agency.successRate}% success',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Navigate to agency detail
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'View Profile',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const Divider(height: 30),

          // Contact Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _ContactItem(icon: Icons.phone, text: agency.phone),
              _ContactItem(icon: Icons.email, text: agency.email),
              // _ContactItem(
              //   icon: Icons.visibility,
              //   text: "${agency.views} views",
              // ),
            ],
          ),
        ],
      ),
    );
  }
}

// ------------------ CONTACT ITEM ------------------
class _ContactItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ContactItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.blue[600]),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------ TRUST BADGE ------------------
class TrustBadge extends StatelessWidget {
  final String trustFactor;

  const TrustBadge({super.key, required this.trustFactor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        trustFactor,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.blue[700],
        ),
      ),
    );
  }
}

// .......Filter......
class FilterSheet extends StatefulWidget {
  const FilterSheet({super.key});

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  bool highlyRated = false;
  bool recentlyEstablished = false;
  RangeValues placementRange = const RangeValues(0, 100);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (context, controller) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Grab handle
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const Text(
                "Filter Agencies",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 20),

              // Highly rated toggle
              SwitchListTile(
                value: highlyRated,
                onChanged: (val) => setState(() => highlyRated = val),
                title: const Text("Highly Rated Agencies"),
                activeColor: Colors.blue,
              ),

              // Established date toggle
              SwitchListTile(
                value: recentlyEstablished,
                onChanged: (val) => setState(() => recentlyEstablished = val),
                title: const Text("Recently Established"),
                activeColor: Colors.blue,
              ),

              const SizedBox(height: 20),
              const Text(
                "Placement Count",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              RangeSlider(
                values: placementRange,
                min: 0,
                max: 500,
                divisions: 10,
                activeColor: Colors.blue,
                labels: RangeLabels(
                  placementRange.start.round().toString(),
                  placementRange.end.round().toString(),
                ),
                onChanged: (values) {
                  setState(() => placementRange = values);
                },
              ),
              const Spacer(),

              // Apply Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    // TODO: Apply filter logic with provider/state mgmt
                  },
                  child: const Text(
                    "Apply Filters",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
