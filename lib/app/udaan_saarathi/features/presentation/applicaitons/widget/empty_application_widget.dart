import 'package:flutter/material.dart';

class EmptyApplicationsState extends StatelessWidget {
  final VoidCallback onFindJobs;

  const EmptyApplicationsState({
    super.key,
    required this.onFindJobs,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Briefcase Icon
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.work_outline,
                size: 64,
                color: Colors.grey.shade400,
              ),
            ),

            const SizedBox(height: 24),

            // Title
            const Text(
              'No Applications Yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),

            const SizedBox(height: 12),

            // Description
            Text(
              'You haven\'t applied for any jobs.\nStart your search to find your next\nopportunity!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                height: 1.5,
                color: Colors.grey[600],
              ),
            ),

            const SizedBox(height: 32),

            // Find Jobs Button
            ElevatedButton(
              onPressed: onFindJobs,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF006BA3),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              child: const Text(
                'Find Jobs',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
