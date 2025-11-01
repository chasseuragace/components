import 'package:flutter/material.dart';
import 'package:variant_dashboard/app/variant_dashboard/features/variants/domain/entities/manpower_agency.dart';

class AgencyDetailScreen3 extends StatefulWidget {
  final ManpowerAgency agency;

  const AgencyDetailScreen3({super.key, required this.agency});

  @override
  _AgencyDetailScreen3State createState() => _AgencyDetailScreen3State();
}

class _AgencyDetailScreen3State extends State<AgencyDetailScreen3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: const Text(
          'Manpower Details',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildConstructionCrewCard(),
            const SizedBox(height: 24),
            _buildPositionsHiringSection(),
            const SizedBox(height: 24),
            _buildJobOpeningsSection(),
            const SizedBox(height: 24),
            _buildLocationSection(),
            const SizedBox(height: 24),
            _buildReviewsSection(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildConstructionCrewCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Construction Crew Illustration
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF3B82F6).withOpacity(0.1),
                  const Color(0xFF1E40AF).withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              children: [
                // Background elements
                Positioned(
                  top: 20,
                  right: 20,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E40AF).withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                // Construction workers illustration (simplified)
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildWorkerAvatar(
                        const Color(0xFF3B82F6),
                        Icons.construction,
                      ),
                      _buildWorkerAvatar(
                        const Color(0xFF1E40AF),
                        Icons.engineering,
                      ),
                      _buildWorkerAvatar(const Color(0xFF2563EB), Icons.build),
                    ],
                  ),
                ),
                // Construction truck (simplified)
                Positioned(
                  bottom: 30,
                  right: 30,
                  child: Container(
                    width: 80,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.local_shipping,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Agency Title and Info
          Text(
            'Construction Crew',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
            ),
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF3B82F6).withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, size: 16, color: const Color(0xFF3B82F6)),
                    const SizedBox(width: 4),
                    Text(
                      '4.8 (25 reviews)',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF3B82F6),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF10B981).withOpacity(0.3),
                  ),
                ),
                child: Text(
                  'Contact - Reviews - View Link',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF10B981),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Contact Information
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              children: [
                _buildContactRow(
                  Icons.location_on,
                  'LOCATION:',
                  '123 Main Street, Anytown',
                  const Color(0xFF3B82F6),
                ),
                const SizedBox(height: 12),
                _buildContactRow(
                  Icons.email,
                  'Email:',
                  'crew@example.com',
                  const Color(0xFF3B82F6),
                ),
                const SizedBox(height: 12),
                _buildContactRow(
                  Icons.phone,
                  'Phone:',
                  '+1 (555) 123-4567',
                  const Color(0xFF3B82F6),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Description
          Text(
            'Our construction crew is highly skilled and experienced in various construction projects. We ensure quality workmanship and timely completion.',
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Colors.grey[700],
            ),
          ),

          const SizedBox(height: 16),

          Text(
            'Read more',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF3B82F6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkerAvatar(Color color, IconData icon) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(icon, color: Colors.white, size: 24),
    );
  }

  Widget _buildContactRow(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF0F172A),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPositionsHiringSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Positions Hiring',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 1.8,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: [
              _buildPositionCard(
                'Construction Worker',
                '45',
                Icons.construction,
                const Color(0xFF3B82F6),
              ),
              _buildPositionCard(
                'Machine Operator',
                '32',
                Icons.precision_manufacturing,
                const Color(0xFF1E40AF),
              ),
              _buildPositionCard(
                'Site Supervisor',
                '12',
                Icons.engineering,
                const Color(0xFF2563EB),
              ),
              _buildPositionCard(
                'Safety Inspector',
                '8',
                Icons.security,
                const Color(0xFF1D4ED8),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPositionCard(
    String title,
    String count,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: color),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  count,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildJobOpeningsSection() {
    final jobs = [
      {
        'title': 'Construction Worker',
        'location': 'Dubai, UAE',
        'salary': '\$2,500/month',
        'type': 'Full-time',
        'urgent': false,
      },
      {
        'title': 'Site Supervisor',
        'location': 'Qatar',
        'salary': '\$3,200/month',
        'type': 'Contract',
        'urgent': true,
      },
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Job Openings',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              final job = jobs[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  job['title'] as String,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                              ),
                              if (job['urgent'] as bool)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFFEF4444,
                                    ).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    'URGENT',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFFEF4444),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 14,
                                color: Colors.grey[500],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                job['location'] as String,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Icon(
                                Icons.attach_money,
                                size: 14,
                                color: Colors.grey[500],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                job['salary'] as String,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF10B981),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3B82F6),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF3B82F6).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Text(
                        'Apply',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Location',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF3B82F6).withOpacity(0.1),
                  const Color(0xFF1E40AF).withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: const Color(0xFF3B82F6).withOpacity(0.2),
              ),
            ),
            child: Stack(
              children: [
                // Map-like background pattern
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: const Color(0xFFE0F2FE).withOpacity(0.3),
                    ),
                    child: CustomPaint(painter: MapPatternPainter()),
                  ),
                ),
                // Location marker
                Center(
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF3B82F6).withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
                // Tap to open text
                Positioned(
                  bottom: 16,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF3B82F6).withOpacity(0.3),
                        ),
                      ),
                      child: const Text(
                        'Tap to open in maps',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF3B82F6),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection() {
    final reviews = [
      {
        'name': 'Liam Carter',
        'timeAgo': '1 month ago',
        'rating': 5,
        'comment':
            'Excellent work and very professional crew. Highly recommend!',
        'avatar': 'LC',
      },
      {
        'name': 'Olivia Bennett',
        'timeAgo': '2 months ago',
        'rating': 4,
        'comment': 'Good service, but there were some minor delays.',
        'avatar': 'OB',
      },
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Reviews',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 20),

          // Overall rating
          Row(
            children: [
              const Text(
                '4.8',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          Icons.star,
                          size: 20,
                          color: index < 4
                              ? const Color(0xFFFBBF24)
                              : Colors.grey[300],
                        );
                      }),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '25 reviews',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Rating breakdown
          Column(
            children: [
              _buildRatingBar(5, 0.8),
              _buildRatingBar(4, 0.1),
              _buildRatingBar(3, 0.05),
              _buildRatingBar(2, 0.03),
              _buildRatingBar(1, 0.02),
            ],
          ),

          const SizedBox(height: 24),

          // Individual reviews
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              final review = reviews[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: const Color(0xFF3B82F6).withOpacity(0.1),
                      child: Text(
                        review['avatar'] as String,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF3B82F6),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                review['name'] as String,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                review['timeAgo'] as String,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: List.generate(5, (starIndex) {
                              return Icon(
                                Icons.star,
                                size: 16,
                                color: starIndex < (review['rating'] as int)
                                    ? const Color(0xFFFBBF24)
                                    : Colors.grey[300],
                              );
                            }),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            review['comment'] as String,
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.4,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 20),

          // Write a Review button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Handle write review action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Write a Review',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBar(int stars, double percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            '$stars',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 8,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: percentage,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBBF24),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${(percentage * 100).toInt()}%',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for map-like pattern
class MapPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF3B82F6).withOpacity(0.1)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Draw grid pattern to simulate map
    final gridSize = 30.0;
    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Draw some curved lines to simulate roads
    final roadPaint = Paint()
      ..color = const Color(0xFF3B82F6).withOpacity(0.2)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, size.height * 0.3);
    path.quadraticBezierTo(
      size.width * 0.3,
      size.height * 0.1,
      size.width * 0.7,
      size.height * 0.4,
    );
    path.quadraticBezierTo(
      size.width * 0.9,
      size.height * 0.5,
      size.width,
      size.height * 0.7,
    );
    canvas.drawPath(path, roadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
