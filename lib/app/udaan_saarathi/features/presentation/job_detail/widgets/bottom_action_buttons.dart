import 'package:flutter/material.dart';

class BottomActionButtons extends StatelessWidget {
  final VoidCallback? onApply;
  final VoidCallback? onContact;
  final VoidCallback? onWebView;

  const BottomActionButtons({
    super.key,
    this.onApply,
    this.onContact,
    this.onWebView,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE2E8F0), width: 1)),
      ),
      child: Row(
        children: [
          // Apply Now Button - Blue Background
          Expanded(
            flex: 1,
            child: ElevatedButton.icon(
              onPressed: onApply ?? () {},
              icon: const Icon(Icons.send, color: Colors.white, size: 18),
              label: const Text(
                'Apply Now',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Contact Us Button - Green Background
          Expanded(
            flex: 1,
            child: ElevatedButton.icon(
              onPressed: onContact ?? () {},
              icon: const Icon(Icons.phone, color: Colors.white, size: 18),
              label: const Text(
                'Contact Us',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Webview Button - No Background
          Expanded(
            flex: 1,
            child: OutlinedButton.icon(
              onPressed: onWebView ?? () {},
              icon: const Icon(Icons.web, color: Color(0xFF64748B), size: 18),
              label: const Text(
                'Web View',
                style: TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: const Color(0xFF64748B),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
