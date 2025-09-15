import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/jobs/providers/providers.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/preferences/providers/preferences_config_provider.dart';
import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/variants/pages/home/home_page_variant1.dart';
import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/variants/pages/home/job_posting.dart';
import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/variants/pages/home/job_posting_mapper.dart';
import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/variants/pages/home/widgets/job_post_card.dart';

class RecommendedJobsSection extends ConsumerWidget {
  // Changed to ConsumerWidget
  const RecommendedJobsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobsState = ref.watch(getGroupedJobsProvider);
    ref.listen(userPreferencesProvider,(p,n){
      ref.invalidate(getGroupedJobsProvider);
    });
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recommended Jobs',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'View All',
                  style: TextStyle(
                    color: Color(0xFF4F7DF9),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          ...jobsState.when(data: (grouped) {
            // Render groups with their jobs mapped to JobPosting
            return grouped.groups.expand<Widget>((group) {
              final List<JobPosting> postings = group.jobs
                  .map((j) => JobPostingMapper.fromGroupJob(j))
                  .toList(growable: false);

              return <Widget>[
                if (group.jobs.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
                    child: Text(
                      group.title + " (${group.jobs.length})",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF374151),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                _GroupPostingsPager(postings: postings),
                const SizedBox(height: 16),
              ];
            }).toList();
          }, error: (e, s) {
            return [
              Text(
                'Failed to load jobs',
                style: TextStyle(color: Colors.red[700]),
              ),
            ];
          }, loading: () {
            return [
              const Center(child: CircularProgressIndicator()),
            ];
          })
        ],
      ),
    );
  }
}


class _GroupPostingsPager extends StatefulWidget {
  final List<JobPosting> postings;

  const _GroupPostingsPager({required this.postings});

  @override
  State<_GroupPostingsPager> createState() => _GroupPostingsPagerState();
}

class _GroupPostingsPagerState extends State<_GroupPostingsPager> {
  double? _measuredCardHeight;

  @override
  Widget build(BuildContext context) {
    // Fallback height while measuring
    final fallbackHeight = 360.0;
    final pageHeight = (_measuredCardHeight != null)
        ? (_measuredCardHeight! * 1.1).clamp(240.0, 640.0)
        : fallbackHeight;

    // Render an offstage first card to measure its height once
    final hasItems = widget.postings.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (hasItems)
          Offstage(
            offstage: true,
            child: _SizeReportingWidget(
              onSize: (size) {
                if (_measuredCardHeight == null ||
                    (_measuredCardHeight! - size.height).abs() > 1.0) {
                  setState(() => _measuredCardHeight = size.height);
                }
              },
              child: JobPostingCard(posting: widget.postings.first),
            ),
          ),
              if (hasItems)
        SizedBox(
          height: pageHeight,
          child: PageView.builder(
            clipBehavior: Clip.none,
            controller: PageController(viewportFraction: .98),
            padEnds: false,
            itemCount: widget.postings.length,
            itemBuilder: (context, index) {
              final p = widget.postings[index];
              return Padding(
                padding: EdgeInsets.only(
                  right: index == widget.postings.length - 1 ? 0 : 12,
                ),
                child: JobPostingCard(posting: p),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SizeReportingWidget extends StatefulWidget {
  final Widget child;
  final ValueChanged<Size> onSize;

  const _SizeReportingWidget({required this.child, required this.onSize});

  @override
  State<_SizeReportingWidget> createState() => _SizeReportingWidgetState();
}

class _SizeReportingWidgetState extends State<_SizeReportingWidget> {
  Size? _oldSize;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = context.size;
      if (size != null && _oldSize != size) {
        _oldSize = size;
        widget.onSize(size);
      }
    });
    return widget.child;
  }
}
