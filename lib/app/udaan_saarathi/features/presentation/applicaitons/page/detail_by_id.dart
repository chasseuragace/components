import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/applicaitons/application_details_entity.dart';
import '../../../domain/entities/applicaitons/entity.dart';
import '../providers/providers.dart';

class ApplicationDetailPage extends ConsumerWidget {
  const ApplicationDetailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applicationState = ref.watch(getApplicaitonsByIdProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Application Details'),
      ),
      body: applicationState.when(
        data: (application) {
          if (application == null) {
            return const Center(child: Text('No application selected'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSection('Application Info', [
                  _buildInfoRow('ID', application.id),
                  _buildInfoRow('Status', application.status),
                  _buildInfoRow('Candidate ID', application.candidateId),
                  _buildInfoRow('Job Posting ID', application.jobPostingId),
                ]),
                const SizedBox(height: 24),
                _buildSection('Timestamps', [
                  _buildInfoRow('Created At', _formatDateTime(application.createdAt)),
                  _buildInfoRow('Updated At', _formatDateTime(application.updatedAt)),
                  if (application.withdrawnAt != null)
                    _buildInfoRow('Withdrawn At', _formatDateTime(application.withdrawnAt!)),
                ]),
                const SizedBox(height: 24),
                _buildHistorySection(application.historyBlob),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: ${error.toString()}'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistorySection(List<ApplicationHistoryEntity> historyBlob) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Status History',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        if (historyBlob.isEmpty)
          const Text('No history available')
        else
          ...historyBlob.map((history) => Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (history.prevStatus != null) ...[
                            Chip(
                              label: Text(history.prevStatus!),
                              backgroundColor: Colors.grey[300],
                            ),
                            const Icon(Icons.arrow_forward, size: 16),
                          ],
                          Chip(
                            label: Text(history.nextStatus),
                            backgroundColor: Colors.blue[100],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Updated: ${_formatDateTime(history.updatedAt)}',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        'By: ${history.updatedBy}',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      if ((history.note??'').isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Note: ${history.note}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ],
                  ),
                ),
              )),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}