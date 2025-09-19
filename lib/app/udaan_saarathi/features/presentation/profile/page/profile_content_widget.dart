import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/candidate/providers/providers.dart' as cand;

class ProfileContentWidget extends ConsumerStatefulWidget {
  const ProfileContentWidget({super.key});

  @override
  ConsumerState<ProfileContentWidget> createState() => _ProfileContentWidgetState();
}

class _ProfileContentWidgetState extends ConsumerState<ProfileContentWidget> {
  bool _fetched = false;

  @override
  void initState() {
    super.initState();
    // Trigger candidate fetch once; repository uses stored candidate_id
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_fetched) {
        _fetched = true;
        ref.read(cand.getCandidateByIdProvider.notifier).getCandidateById('');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final candidateAsync = ref.watch(cand.getCandidateByIdProvider);
    final name = candidateAsync.asData?.value?.fullName ?? 'Your Name';

    return Column(
      children: [
        Stack(
          children: [
            const CircleAvatar(
              radius: 55,
              backgroundColor: Color(0xFFF0F0F0),
              backgroundImage: NetworkImage(
                "https://i.pravatar.cc/150?img=47",
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  // Handle profile image edit
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          name,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          "Software Developer",
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            "Available for hire",
            style: TextStyle(
              fontSize: 12,
              color: Colors.green,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
