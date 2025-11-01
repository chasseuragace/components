import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/notification/entity.dart';
import '../providers/providers.dart';

class NotificationListPage extends ConsumerStatefulWidget {
  const NotificationListPage({Key? key}) : super(key: key);

  @override
  ConsumerState<NotificationListPage> createState() => _NotificationListPageState();
}

class _NotificationListPageState extends ConsumerState<NotificationListPage> {
  final ScrollController _scrollController = ScrollController();
  BuildContext? barrierContext;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      ref.read(notificationListProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final notificationState = ref.watch(notificationListProvider);
    
    _listenToMarkAsReadAction(context);
    _listenToMarkAllAsReadAction(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          // Unread filter toggle
          Consumer(
            builder: (context, ref, child) {
              final notifier = ref.read(notificationListProvider.notifier);
              return IconButton(
                icon: Icon(
                  notifier.isUnreadFilterActive 
                      ? Icons.mark_email_unread 
                      : Icons.mark_email_read,
                ),
                onPressed: () {
                  notifier.toggleUnreadFilter();
                },
                tooltip: notifier.isUnreadFilterActive 
                    ? 'Show all notifications' 
                    : 'Show unread only',
              );
            },
          ),
          // Mark all as read button
          IconButton(
            icon: const Icon(Icons.done_all),
            onPressed: () => _showMarkAllAsReadConfirmation(context),
            tooltip: 'Mark all as read',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(notificationListProvider.notifier).refresh(),
        child: notificationState.when(
          data: (state) => state.items.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.notifications_none, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No notifications available',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    // Notification count header
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      color: Colors.grey[100],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total: ${state.total} notifications',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          if (state.unreadCount > 0)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${state.unreadCount} unread',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    // Notification list
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: state.items.length + (state.hasMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == state.items.length) {
                            // Loading indicator for pagination
                            return const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                          
                          final notification = state.items[index];
                          return NotificationTile(
                            notification: notification,
                            onMarkAsRead: () => _markAsRead(notification.id),
                            onTap: () => _onNotificationTap(notification),
                          );
                        },
                      ),
                    ),
                  ],
                ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error loading notifications',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.read(notificationListProvider.notifier).refresh(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _listenToMarkAsReadAction(BuildContext context) {
    ref.listen<AsyncValue>(markAsReadProvider, (previous, next) {
      if (next.isLoading) {
        _showLoadingDialog(context);
      } else if (previous?.isLoading == true && next.hasError) {
        _hideLoadingDialog();
        _showErrorSnackBar(context, "Failed to mark as read: ${next.error}");
      } else if (previous?.isLoading == true && next.hasValue) {
        _hideLoadingDialog();
        _showSuccessSnackBar(context, "Notification marked as read");
      }
    });
  }

  void _listenToMarkAllAsReadAction(BuildContext context) {
    ref.listen<AsyncValue>(markAllAsReadProvider, (previous, next) {
      if (next.isLoading) {
        _showLoadingDialog(context);
      } else if (previous?.isLoading == true && next.hasError) {
        _hideLoadingDialog();
        _showErrorSnackBar(context, "Failed to mark all as read: ${next.error}");
      } else if (previous?.isLoading == true && next.hasValue) {
        _hideLoadingDialog();
        _showSuccessSnackBar(context, "All notifications marked as read");
      }
    });
  }

  void _markAsRead(String notificationId) {
    ref.read(markAsReadProvider.notifier).markAsRead(notificationId);
  }

  void _showMarkAllAsReadConfirmation(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mark All as Read'),
        content: const Text('Are you sure you want to mark all notifications as read?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Mark All as Read'),
          ),
        ],
      ),
    );

    if (result == true) {
      ref.read(markAllAsReadProvider.notifier).markAllAsRead();
    }
  }

  void _onNotificationTap(NotificationEntity notification) {
    // Handle notification tap - could navigate to detail page or perform action
    if (!notification.isRead) {
      _markAsRead(notification.id);
    }
    
    // TODO: Add navigation to notification detail page or relevant screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tapped: ${notification.title}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showLoadingDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        barrierContext = context;
        return Container(
          color: Colors.black38,
          child: const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  void _hideLoadingDialog() {
    if (barrierContext != null) {
      Navigator.of(barrierContext!).pop();
      barrierContext = null;
    }
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class NotificationTile extends StatefulWidget {
  final NotificationEntity notification;
  final VoidCallback onMarkAsRead;
  final VoidCallback onTap;

  const NotificationTile({
    Key? key,
    required this.notification,
    required this.onMarkAsRead,
    required this.onTap,
  }) : super(key: key);

  @override
  State<NotificationTile> createState() => _NotificationTileState();
}

class _NotificationTileState extends State<NotificationTile> {
  bool _isExpanded = false;
  bool _hasBeenRead = false;

  @override
  Widget build(BuildContext context) {
    final notification = widget.notification;
    final isRead = _hasBeenRead || notification.isRead;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: isRead ? 1 : 3,
      child: ExpansionTile(
        key: ValueKey(notification.id),
        leading: CircleAvatar(
          backgroundColor: _getNotificationColor(notification.notificationType),
          child: Icon(
            _getNotificationIcon(notification.notificationType),
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
            color: isRead ? Colors.grey[600] : Colors.black,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              notification.message,
              style: TextStyle(
                color: isRead ? Colors.grey[500] : Colors.grey[700],
              ),
              maxLines: _isExpanded ? 10 : 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (!_isExpanded) ...[  
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.business, size: 14, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      notification.payload.agencyName,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    _formatTime(notification.createdAt),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
        trailing: !isRead
            ? const Icon(Icons.keyboard_arrow_down, color: Colors.blue)
            : null,
        initiallyExpanded: false,
        onExpansionChanged: (expanded) {
          setState(() {
            _isExpanded = expanded;
            if (expanded && !isRead) {
              // Mark as read when expanded
              widget.onMarkAsRead();
              setState(() {
                _hasBeenRead = true;
              });
            }
          });
          if (expanded) {
            widget.onTap();
          }
        },
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.business, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Text(
                      notification.payload.agencyName,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const Spacer(),
                    Text(
                      _formatDetailedTime(notification.createdAt),
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
                ...(notification.payload.interviewDetails != null 
                  ? [
                      const SizedBox(height: 8),
                      const Text(
                        'Interview Details:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildDetailRow(Icons.calendar_today, 'Date', notification.payload.interviewDetails!.date),
                      const SizedBox(height: 4),
                      _buildDetailRow(Icons.access_time, 'Time', notification.payload.interviewDetails!.time),
                      const SizedBox(height: 4),
                      _buildDetailRow(Icons.location_on, 'Location', notification.payload.interviewDetails!.location),
                    ]
                  : [
                      const SizedBox(height: 8),
                      _buildDetailRow(Icons.work, 'Job', notification.payload.jobTitle),
                    ]
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.shortlisted:
        return Colors.green;
      case NotificationType.interviewScheduled:
        return Colors.blue;
      case NotificationType.interviewRescheduled:
        return Colors.orange;
      case NotificationType.interviewPassed:
        return Colors.purple;
      case NotificationType.interviewFailed:
        return Colors.red;
    }
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.shortlisted:
        return Icons.check_circle;
      case NotificationType.interviewScheduled:
        return Icons.schedule;
      case NotificationType.interviewRescheduled:
        return Icons.update;
      case NotificationType.interviewPassed:
        return Icons.celebration;
      case NotificationType.interviewFailed:
        return Icons.cancel;
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDetailedTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

