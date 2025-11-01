import 'package:flutter/material.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/colors/app_colors.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/routes/route_constants.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/domain/entities/notifications/entity.dart';

class NotificationCardWidget extends StatefulWidget {
  final JobNotificationEntity notification;

  const NotificationCardWidget({
    super.key,
    required this.notification,
  });

  @override
  State<NotificationCardWidget> createState() => _NotificationCardWidgetState();
}

class _NotificationCardWidgetState extends State<NotificationCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, RouteConstants.kNotificationDetailScreen,
            arguments: widget.notification);
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => NotificationDetailPage(
        //       notification: widget.notification,
        //     ),
        //   ),
        // );
      },
      onTapDown: (_) {
        setState(() => _isHovered = true);
        _hoverController.forward();
      },
      onTapUp: (_) {
        setState(() => _isHovered = false);
        _hoverController.reverse();
      },
      onTapCancel: () {
        setState(() => _isHovered = false);
        _hoverController.reverse();
      },
      child: AnimatedBuilder(
        animation: _hoverController,
        builder: (context, child) {
          final scale = 1.0 - (_hoverController.value * 0.02);
          return Transform.scale(
            scale: scale,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white,
                    Colors.white.withOpacity(0.95),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: _getStatusColor(widget.notification.status)
                        .withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 40,
                    offset: const Offset(0, 16),
                    spreadRadius: -4,
                  ),
                ],
                border: widget.notification.isNew
                    ? Border.all(
                        color: _getStatusColor(widget.notification.status)
                            .withOpacity(0.3),
                        width: 1,
                      )
                    : null,
              ),
              child: Stack(
                children: [
                  // New notification indicator
                  if (widget.notification.isNew)
                    Positioned(
                      top: 20,
                      right: 20,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _getStatusColor(widget.notification.status),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: _getStatusColor(widget.notification.status)
                                  .withOpacity(0.5),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ),

                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Company Logo with shadow
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    _getStatusColor(widget.notification.status)
                                        .withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              color:
                                  _getStatusColor(widget.notification.status),
                              child: Center(
                                child: Text(
                                  widget.notification.companyName
                                      .substring(0, 2)
                                      .toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 20),

                        // Content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Job Title
                              Text(
                                widget.notification.jobTitle,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0F172A),
                                  height: 1.2,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              const SizedBox(height: 6),

                              // Company Name
                              Text(
                                widget.notification.companyName,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF64748B),
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Description
                              Text(
                                widget.notification.description!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF64748B),
                                  height: 1.4,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 16),

                              // Status and Timestamp Row
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Status Tag with enhanced styling
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          _getStatusColor(
                                              widget.notification.status),
                                          _getStatusColor(
                                                  widget.notification.status)
                                              .withOpacity(0.8),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: _getStatusColor(
                                                  widget.notification.status)
                                              .withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          _getStatusIcon(
                                              widget.notification.status),
                                          size: 14,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          _getStatusText(
                                              widget.notification.status),
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                            letterSpacing: 0.3,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Timestamp with icon
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.access_time_rounded,
                                        size: 14,
                                        color: const Color(0xFF94A3B8),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        widget.notification.timestamp,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF94A3B8),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getStatusColor(NotificationStatus status) {
    switch (status) {
      case NotificationStatus.shortlisted:
        return const Color(0xFF10B981);
      case NotificationStatus.rejected:
        return AppColors.kred;
      case NotificationStatus.underReview:
        return AppColors.korange;
      case NotificationStatus.interview:
        return AppColors.primaryColor;
    }
  }

  IconData _getStatusIcon(NotificationStatus status) {
    switch (status) {
      case NotificationStatus.shortlisted:
        return Icons.check_circle_rounded;
      case NotificationStatus.rejected:
        return Icons.cancel_rounded;
      case NotificationStatus.underReview:
        return Icons.hourglass_empty_rounded;
      case NotificationStatus.interview:
        return Icons.calendar_today_rounded;
    }
  }

  String _getStatusText(NotificationStatus status) {
    switch (status) {
      case NotificationStatus.shortlisted:
        return 'Shortlisted';
      case NotificationStatus.rejected:
        return 'Rejected';
      case NotificationStatus.underReview:
        return 'Under Review';
      case NotificationStatus.interview:
        return 'Interview';
    }
  }
}
