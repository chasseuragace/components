import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/image_upload/image_pick_and_crop_provider.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/candidate/providers/providers.dart'
    as cand;
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/profile/widgets/image_source_selection_prompt.dart';

class ProfileContentWidget extends ConsumerStatefulWidget {
  const ProfileContentWidget({super.key});

  @override
  ConsumerState<ProfileContentWidget> createState() =>
      _ProfileContentWidgetState();
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
        ref.read(cand.getCandidateByIdProvider.notifier).getCandidateById();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final candidateAsync = ref.watch(cand.getCandidateByIdProvider);
    ref.listen<AsyncValue>(cand.updateCandidateProvider, (previous, next) {
      ref.refresh(cand.getCandidateByIdProvider);
    });
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
                onTap: () async {
                  final source = await showDialog(
                    context: context,
                    builder: (context) => const ImageSourceSelectionPrompt(),
                  );
                  if (source == null) {
                    return;
                  }
                  final image =
                      await ref.read(imagePickAndCropProvider).pickAndCropImage(
                    imageSource: source,
                    imageRatioPresets: [
                      CropAspectRatioPreset.square,
                    ],
                  );
                  print(image?.path);
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
        candidateAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: CircularProgressIndicator(),
          ),
          error: (err, st) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Failed to load profile',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.red),
            ),
          ),
          data: (candidate) {
            final displayName = candidate?.fullName ?? 'Your Name';
            final phone = candidate?.phone;
            final address = candidate?.address;

            String? addressText;
            if (address != null) {
              final parts = <String>[];
              if ((address.name ?? '').trim().isNotEmpty)
                parts.add(address.name!.trim());
              if ((address.municipality ?? '').trim().isNotEmpty)
                parts.add(address.municipality!.trim());
              if ((address.district ?? '').trim().isNotEmpty)
                parts.add(address.district!.trim());
              if ((address.province ?? '').trim().isNotEmpty)
                parts.add(address.province!.trim());
              if ((address.ward ?? '').trim().isNotEmpty)
                parts.add('Ward ${address.ward!.trim()}');
              addressText = parts.isNotEmpty ? parts.join(', ') : null;
            }

            return Column(
              children: [
                Text(
                  displayName,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                if (phone != null && phone.trim().isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.phone, size: 16, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text(
                        phone,
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black87),
                      ),
                    ],
                  ),
                ],
                if (addressText != null) ...[
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.location_on,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          addressText,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}
