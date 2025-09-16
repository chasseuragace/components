import 'package:flutter/material.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/colors/app_colors.dart';
import 'package:variant_dashboard/app/variant_dashboard/features/variants/domain/entities/manpower_agency.dart';

class AgencyListingScreen1 extends StatefulWidget {
  const AgencyListingScreen1({super.key});

  @override
  _AgencyListingScreen1State createState() => _AgencyListingScreen1State();
}

class _AgencyListingScreen1State extends State<AgencyListingScreen1> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Manpower Agencies',
          style: TextStyle(
            color: Colors.grey[900],
            fontWeight: FontWeight.w600,
            fontSize: 24,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.white,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search agencies by name or location...',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ),
          // Agency List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _getFilteredAgencies().length,
              itemBuilder: (context, index) {
                return ManpowerCard(agency: _getFilteredAgencies()[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  List<ManpowerAgency> _getFilteredAgencies() {
    if (_searchQuery.isEmpty) {
      return sampleAgencies;
    }
    return sampleAgencies
        .where(
          (agency) =>
              agency.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              agency.location.toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  ),
        )
        .toList();
  }
}

class ManpowerCard extends StatelessWidget {
  final ManpowerAgency agency;

  const ManpowerCard({super.key, required this.agency});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor,
            blurRadius: 10,
            offset: Offset(0, 2),
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
                        style: TextStyle(
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
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.blue[600],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.check, size: 12, color: Colors.white),
                      ),
                    ),
                ],
              ),
              SizedBox(width: 16),
              // Agency Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      agency.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[900],
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 16,
                          color: Colors.grey[500],
                        ),
                        SizedBox(width: 4),
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
          SizedBox(height: 16),

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
          SizedBox(height: 16),

          // Trust Factors
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: agency.trustFactors.map((factor) {
              return TrustBadge(trustFactor: factor);
            }).toList(),
          ),
          SizedBox(height: 16),

          // Specializations
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              ...agency.specializations.take(3).map((spec) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
          SizedBox(height: 20),

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
                        SizedBox(width: 4),
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
                    SizedBox(width: 16),
                    Row(
                      children: [
                        Icon(
                          Icons.trending_up,
                          size: 16,
                          color: Colors.grey[500],
                        ),
                        SizedBox(width: 4),
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
              // Action Button
              ElevatedButton(
                onPressed: () {
                  // Navigate to agency detail
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'View Profile',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TrustBadge extends StatelessWidget {
  final TrustFactor trustFactor;

  const TrustBadge({super.key, required this.trustFactor});

  @override
  Widget build(BuildContext context) {
    final badgeStyle = _getBadgeStyle(trustFactor.type);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: badgeStyle['bgColor'],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: badgeStyle['borderColor']!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(badgeStyle['icon'], size: 14, color: badgeStyle['textColor']),
          SizedBox(width: 4),
          Text(
            trustFactor.displayText,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: badgeStyle['textColor'],
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getBadgeStyle(TrustFactorType type) {
    switch (type) {
      case TrustFactorType.established:
        return {
          'bgColor': Colors.blue[50],
          'textColor': Colors.blue[700],
          'borderColor': Colors.blue[200],
          'icon': Icons.calendar_today,
        };
      case TrustFactorType.employees:
        return {
          'bgColor': Colors.green[50],
          'textColor': Colors.green[700],
          'borderColor': Colors.green[200],
          'icon': Icons.groups,
        };
      case TrustFactorType.rating:
        return {
          'bgColor': Colors.amber[50],
          'textColor': Colors.amber[700],
          'borderColor': Colors.amber[200],
          'icon': Icons.star,
        };
      case TrustFactorType.verified:
        return {
          'bgColor': Colors.blue[50] ?? Colors.green[50],
          'textColor': Colors.blue[700] ?? Colors.green[700],
          'borderColor': Colors.blue[200] ?? Colors.green[200],
          'icon': Icons.verified_user,
        };
    }
  }
}

// Data Models
