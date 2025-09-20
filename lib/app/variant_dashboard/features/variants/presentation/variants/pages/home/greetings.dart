import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/jobs/grouped_jobs.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/candidate/providers/providers.dart' as cand;
import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/variants/pages/home/dashboard_header.dart';
import 'package:variant_dashboard/app/variant_dashboard/features/variants/presentation/variants/pages/home/home_page_variant1.dart';

import '../../../../../../../udaan_saarathi/features/presentation/jobs/providers/providers.dart';

class Greetings extends ConsumerWidget {
  const Greetings({
    super.key,

  });




  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final candState = ref.watch(cand.getCandidateByIdProvider);
    final  count = ref.watch(getGroupedJobsProvider);
    final name = candState.when(
      data: (c) => (c?.fullName?.trim().isNotEmpty == true) ? c!.fullName! : 'Guest',
      loading: () => '...',
      error: (_, __) => 'Guest',
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Good ${getGreeting()},',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withOpacity(0.8),
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          name,
          style: TextStyle(
            fontSize: 28,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8.0),
        
        count.when(data: (GroupedJobsEntity data) { 
          return  jobCOunts(data.groups.expand((e)=>e.jobs).length.toString());
         }, error: (Object error, StackTrace stackTrace) { 
          return jobCOunts(0.toString());
          }, loading: () {  return jobCOunts(0.toString());}),
       
      ],
    );
  }

  Text jobCOunts(String  count) {
    return Text(
        '${count} jobs match your profile',
        style: TextStyle(
          fontSize: 16,
          color: Colors.white.withOpacity(0.9),
        ),
      );
  }
}
