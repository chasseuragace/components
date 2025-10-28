import 'package:flutter/material.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/colors/app_colors.dart';
import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/variants/pages/home/job_posting.dart';

class SalarySection extends StatelessWidget {
  final MobileJobEntity job;
  const SalarySection({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF059669).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.attach_money,
                  color: Color(0xFF059669),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Compensation',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Display overall salary range if available
          if (job.salary != null && job.salary != 'Not specified') ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF059669).withOpacity(0.1),
                    const Color(0xFF10B981).withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Salary Range',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  Text(
                    job.salary!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF059669),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Display all positions with their individual salaries
          if (job.positions.isNotEmpty) ...[
            const Text(
              'Positions & Salaries',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 12),
            ...job.positions.asMap().entries.map((entry) {
              final index = entry.key;
              final position = entry.value;
              final isLast = index == job.positions.length - 1;

              return Column(
                children: [
                  _buildPositionCard(position),
                  if (!isLast) const SizedBox(height: 12),
                ],
              );
            }),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'No position details available',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF64748B),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPositionCard(position) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF059669).withOpacity(0.08),
            const Color(0xFF10B981).withOpacity(0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF059669).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Position title
          Row(
            children: [
              const Icon(
                Icons.work_outline,
                size: 18,
                color: Color(0xFF059669),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  position.title ?? 'Position',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          const SizedBox(height: 12),

          // Base salary
          if (position.baseSalary != null &&
              position.baseSalary != 'Not specified') ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Base Salary',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF64748B),
                  ),
                ),
                Row(
                  children: [
                    // if (position.currency != null &&
                    //     position.currency != 'N/A')
                    //   Text(
                    //     '${position.currency} ',
                    //     style: const TextStyle(
                    //       fontSize: 14,
                    //       fontWeight: FontWeight.w600,
                    //       color: Color(0xFF059669),
                    //     ),
                    //   ),
                    Text(
                      position.baseSalary!,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF059669),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],

          // Converted salary
          if (position.convertedSalary != null &&
              position.convertedSalary != 'Not available') ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.currency_exchange,
                      size: 16,
                      color: Color(0xFF64748B),
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Converted',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
                Text(
                  position.convertedSalary!,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF059669),
                  ),
                ),
              ],
            ),
          ],

          // Requirements if available
          if (position.requirements != null &&
              position.requirements!.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Divider(height: 1, color: Color(0xFFE2E8F0)),
            const SizedBox(height: 8),
            const Text(
              'Requirements',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 6),
            ...position.requirements!.take(3).map((req) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle_outline,
                        size: 14,
                        color: Color(0xFF059669),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          req,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF475569),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ],
      ),
    );
  }
}
