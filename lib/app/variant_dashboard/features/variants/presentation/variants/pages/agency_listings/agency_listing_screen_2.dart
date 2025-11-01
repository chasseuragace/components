import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/colors/app_colors.dart';

class AgencyListingScreen2 extends StatefulWidget {
  const AgencyListingScreen2({super.key});

  @override
  _AgencyListingScreen2State createState() => _AgencyListingScreen2State();
}

class _AgencyListingScreen2State extends State<AgencyListingScreen2> {
  final TextEditingController _searchController = TextEditingController();
  final List<Manpower> _manpowers = [];
  final List<Manpower> _filteredManpowers = [];

  @override
  void initState() {
    super.initState();
    _loadManpowers();
    _searchController.addListener(_onSearchChanged);
  }

  void _loadManpowers() {
    // Mock data - replace with your actual data source
    _manpowers.addAll([
      Manpower(
        name: 'TechRecruit Solutions',
        location: 'New York, USA',
        avatarUrl: 'https://example.com/avatar1.jpg',
        employeesSent: 2500,
        establishedDate: DateTime(2005, 1, 1),
        rating: 4.8,
        reviewsCount: 156,
      ),
      Manpower(
        name: 'Global Manpower Inc.',
        location: 'London, UK',
        avatarUrl: 'https://example.com/avatar2.jpg',
        employeesSent: 18000,
        establishedDate: DateTime(1990, 5, 15),
        rating: 4.9,
        reviewsCount: 423,
      ),
      Manpower(
        name: 'CareerBuilders',
        location: 'Toronto, Canada',
        avatarUrl: null,
        employeesSent: 8900,
        establishedDate: DateTime(1998, 8, 20),
        rating: 4.6,
        reviewsCount: 287,
      ),
    ]);
    _filteredManpowers.addAll(_manpowers);
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredManpowers.clear();
      if (query.isEmpty) {
        _filteredManpowers.addAll(_manpowers);
      } else {
        _filteredManpowers.addAll(
          _manpowers.where(
            (manpower) =>
                manpower.name.toLowerCase().contains(query) ||
                manpower.location.toLowerCase().contains(query),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manpower Agencies'),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          _buildSearchBar(),
          _buildFilterChips(),
          // Results count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                Text(
                  '${_filteredManpowers.length} agencies found',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
          ),

          // Manpower List
          Expanded(
            child: _filteredManpowers.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 16),
                    itemCount: _filteredManpowers.length,
                    itemBuilder: (context, index) {
                      final manpower = _filteredManpowers[index];
                      return ManpowerCard(
                        name: manpower.name,
                        location: manpower.location,
                        avatarUrl: manpower.avatarUrl,
                        employeesSent: manpower.employeesSent,
                        establishedDate: manpower.establishedDate,
                        rating: manpower.rating,
                        reviewsCount: manpower.reviewsCount,
                        onTap: () {
                          // Navigate to manpower detail page
                          print('Tapped on ${manpower.name}');
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search manpower agencies...',
          border: InputBorder.none,
          prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: Colors.grey[500]),
                  onPressed: () {
                    _searchController.clear();
                  },
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          FilterChip(
            label: Text('Highly Rated'),
            onSelected: (_) {},
            backgroundColor: Colors.blue[50],
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: Text('Established 10+ years'),
            onSelected: (_) {},
            backgroundColor: Colors.blue[50],
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: Text('1000+ placements'),
            onSelected: (_) {},
            backgroundColor: Colors.blue[50],
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
          Icon(Icons.search_off, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'No agencies found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try different search terms',
            style: TextStyle(color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }
}

class Manpower {
  final String name;
  final String location;
  final String? avatarUrl;
  final int employeesSent;
  final DateTime establishedDate;
  final double rating;
  final int reviewsCount;

  Manpower({
    required this.name,
    required this.location,
    this.avatarUrl,
    required this.employeesSent,
    required this.establishedDate,
    required this.rating,
    required this.reviewsCount,
  });
}

class ManpowerCard extends StatelessWidget {
  final String name;
  final String location;
  final String? avatarUrl;
  final int employeesSent;
  final DateTime establishedDate;
  final double rating;
  final int reviewsCount;
  final VoidCallback? onTap;

  const ManpowerCard({
    super.key,
    required this.name,
    required this.location,
    this.avatarUrl,
    required this.employeesSent,
    required this.establishedDate,
    this.rating = 0.0,
    this.reviewsCount = 0,
    this.onTap,
  });

  String get experienceText {
    final years = DateTime.now().difference(establishedDate).inDays ~/ 365;
    return 'Since ${establishedDate.year} ($years years)';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: AppColors.blackColor,
            blurRadius: 4,
            offset: const Offset(0, 1),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          splashColor: Colors.blue.withOpacity(0.05),
          highlightColor: Colors.blue.withOpacity(0.02),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                _buildAvatar(),
                const SizedBox(width: 18),

                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name and Location
                      _buildBasicInfo(),
                      const SizedBox(height: 16),

                      // Trust Indicators
                      _buildTrustIndicators(),
                      const SizedBox(height: 14),

                      // Rating and Reviews
                      _buildRatingSection(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [Colors.blue.shade400, Colors.blue.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: CircleAvatar(
        radius: 32,
        backgroundColor: Colors.transparent,
        backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
        child: avatarUrl == null
            ? Text(
                name.isNotEmpty ? name[0].toUpperCase() : 'M',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              )
            : null,
      ),
    );
  }

  Widget _buildBasicInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A1A),
            letterSpacing: -0.5,
            height: 1.2,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(
                Icons.location_on,
                size: 16,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                location,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.1,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTrustIndicators() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _buildTrustChip(
          icon: Icons.people_alt_outlined,
          text: '${NumberFormat.compact().format(employeesSent)}+ placed',
          color: Colors.blue,
        ),
        _buildTrustChip(
          icon: Icons.calendar_today_outlined,
          text: experienceText,
          color: Colors.indigo,
        ),
      ],
    );
  }

  Widget _buildTrustChip({
    required IconData icon,
    required String text,
    required MaterialColor color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.shade50, color.shade100.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.shade200.withOpacity(0.5), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: color.shade200.withOpacity(0.3),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(icon, size: 14, color: color.shade700),
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color.shade700,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingSection() {
    return Row(
      children: [
        // Star rating
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: Colors.amber.shade50,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(Icons.star, size: 18, color: Colors.amber.shade600),
        ),
        const SizedBox(width: 6),
        Text(
          rating.toStringAsFixed(1),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A1A),
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(width: 8),

        // Reviews count
        Text(
          '($reviewsCount reviews)',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
          ),
        ),

        const Spacer(),

        // Verified badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.green.shade50,
                Colors.green.shade100.withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.green.shade200.withOpacity(0.6),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.green.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.green.shade200.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Icon(
                  Icons.verified,
                  size: 14,
                  color: Colors.green.shade700,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'Verified',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.green.shade700,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
