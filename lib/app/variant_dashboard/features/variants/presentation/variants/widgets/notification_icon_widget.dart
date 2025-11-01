import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/routes/route_constants.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/notification/providers/providers.dart';

class NotificationIconWidget extends ConsumerWidget {
  const NotificationIconWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unreadCountAsync = ref.watch(unreadCountProvider);

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, RouteConstants.kNotificationScreen);
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.2),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        child: Stack(
          children: [
            const Center(
              child: Icon(
                Icons.notifications,
                color: Colors.white,
                size: 30,
              ),
            ),
            // Unread count badge
            unreadCountAsync.when(
              data: (unreadCount) {
                if (unreadCount > 0) {
                  return Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        unreadCount > 99 ? '99+' : unreadCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
