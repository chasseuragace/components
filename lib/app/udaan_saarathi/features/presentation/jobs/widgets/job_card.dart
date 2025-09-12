import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/jobs/entity.dart';
import 'package:variant_dashboard/app/udaan_saarathi/utils/string_utils.dart';

class JobCard extends StatefulWidget {
  final JobsEntity job;

  const JobCard({super.key, required this.job});

  @override
  State<JobCard> createState() => _JobCardState();
}

class _JobCardState extends State<JobCard> {
  bool isSaved = false;

  @override
  Widget build(BuildContext context) {
    final job = widget.job;

    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => JobDetailScreen(job: job)),
        // );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: job.isFeatured == true
              ? Border.all(
                  color: const Color(0xFF3B82F6).withOpacity(0.3),
                  width: 1,
                )
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
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
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: job.employer.companyLogo.isEmpty
                      ? Center(
                          child: Text(
                            job.employer.companyName.companyInitial,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : CachedNetworkImage(
                          imageUrl: job.employer.companyLogo,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.grey.shade200,
                            child:
                                const Icon(Icons.business, color: Colors.grey),
                          ),
                          errorWidget: (context, url, error) => CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.grey.shade300,
                            child:
                                Text(job.employer.companyLogo.companyInitial),
                          ),
                        ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (job.isFeatured == true) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEF4444),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'FEATURED',
                                style: TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                          Expanded(
                            child: Text(
                              job.postingTitle,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1E293B),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        job.employer.companyName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() => isSaved = !isSaved),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSaved
                          ? const Color(0xFF3B82F6).withOpacity(0.1)
                          : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      isSaved ? Icons.bookmark : Icons.bookmark_border,
                      color: isSaved
                          ? const Color(0xFF3B82F6)
                          : const Color(0xFF64748B),
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: const Color(0xFF64748B),
                ),
                const SizedBox(width: 4),
                Text(
                  job.city,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF64748B),
                  ),
                ),
                // if (job['isRemote'] == true) ...[
                //   const SizedBox(width: 8),
                //   Container(
                //     padding: const EdgeInsets.symmetric(
                //       horizontal: 6,
                //       vertical: 2,
                //     ),
                //     decoration: BoxDecoration(
                //       color: const Color(0xFF10B981).withOpacity(0.1),
                //       borderRadius: BorderRadius.circular(4),
                //     ),
                //     child: const Text(
                //       'Remote',
                //       style: TextStyle(
                //         fontSize: 8,
                //         fontWeight: FontWeight.w600,
                //         color: Color(0xFF10B981),
                //       ),
                //     ),
                //   ),
                // ],
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildJobTag(
                    job.contract.periodYears.toString(), Icons.work_outline),
                const SizedBox(width: 8),
                _buildJobTag(job.experienceRequirements.minYears.toString(),
                    Icons.timeline),
                const SizedBox(width: 8),
                _buildJobTag(job.postingDateAd.timeAgo, Icons.schedule),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Salary',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "NRs. ${job.positions.first.salary.monthlyAmount.toString()}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF059669),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getMatchColor(
                          job.fitnessScore,
                        ).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${job.fitnessScore}% Match',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: _getMatchColor(job.fitnessScore),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Apply',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobTag(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: const Color(0xFF64748B)),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  Color _getMatchColor(int percentage) {
    if (percentage >= 90) return const Color(0xFF059669);
    if (percentage >= 75) return const Color(0xFF0891B2);
    if (percentage >= 60) return const Color(0xFFF59E0B);
    return const Color(0xFFEF4444);
  }
}
