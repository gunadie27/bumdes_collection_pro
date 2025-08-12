import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NotificationListWidget extends StatelessWidget {
  final List<Map<String, dynamic>> notifications;
  final List<Map<String, dynamic>> selectedNotifications;
  final Function(Map<String, dynamic>) onNotificationTap;
  final Function(Map<String, dynamic>) onNotificationLongPress;
  final Function(Map<String, dynamic>) onNotificationSelected;
  final Future<void> Function() onRefresh;

  const NotificationListWidget({
    super.key,
    required this.notifications,
    required this.selectedNotifications,
    required this.onNotificationTap,
    required this.onNotificationLongPress,
    required this.onNotificationSelected,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none,
              size: 20.w,
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.3),
            ),
            SizedBox(height: 2.h),
            Text(
              "Tidak ada notifikasi",
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.6),
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              "Notifikasi baru akan muncul di sini",
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.5),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      color: AppTheme.lightTheme.colorScheme.primary,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(vertical: 1.h),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          final isSelected =
              selectedNotifications.any((n) => n["id"] == notification["id"]);

          return _buildNotificationItem(notification, isSelected);
        },
      ),
    );
  }

  Widget _buildNotificationItem(
      Map<String, dynamic> notification, bool isSelected) {
    final isRead = notification["isRead"] as bool;
    final isImportant = notification["isImportant"] as bool;
    final type = notification["type"] as String;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: isSelected
            ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1)
            : AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(
          color: isSelected
              ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3)
              : isRead
                  ? AppTheme.lightTheme.dividerColor
                  : AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1),
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          if (!isRead) ...[
            BoxShadow(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ] else ...[
            BoxShadow(
              color: AppTheme.shadowLight,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onNotificationTap(notification),
          onLongPress: () => onNotificationLongPress(notification),
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              children: [
                // Main content
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Leading indicators
                    Column(
                      children: [
                        // Avatar or icon
                        Container(
                          width: 12.w,
                          height: 12.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isRead
                                  ? AppTheme.lightTheme.dividerColor
                                  : AppTheme.lightTheme.colorScheme.primary,
                              width: 2,
                            ),
                          ),
                          child: (notification["senderAvatar"] as String)
                                  .isNotEmpty
                              ? ClipOval(
                                  child: CustomImageWidget(
                                    imageUrl:
                                        notification["senderAvatar"] as String,
                                    width: 12.w,
                                    height: 12.w,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    color: _getTypeColor(type)
                                        .withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    _getTypeIcon(type),
                                    color: _getTypeColor(type),
                                    size: 6.w,
                                  ),
                                ),
                        ),

                        // Unread indicator
                        if (!isRead) ...[
                          SizedBox(height: 1.h),
                          Container(
                            width: 2.w,
                            height: 2.w,
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),

                    SizedBox(width: 3.w),

                    // Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header row with title and indicators
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  notification["title"] as String,
                                  style: AppTheme
                                      .lightTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    fontWeight: isRead
                                        ? FontWeight.w500
                                        : FontWeight.w700,
                                    color: isRead
                                        ? AppTheme
                                            .lightTheme.colorScheme.onSurface
                                        : AppTheme
                                            .lightTheme.colorScheme.onSurface,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),

                              // Important indicator
                              if (isImportant) ...[
                                SizedBox(width: 2.w),
                                Icon(
                                  Icons.priority_high,
                                  color: AppTheme.errorLight,
                                  size: 4.w,
                                ),
                              ],

                              // Selection indicator
                              if (isSelected) ...[
                                SizedBox(width: 2.w),
                                Icon(
                                  Icons.check_circle,
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  size: 5.w,
                                ),
                              ],
                            ],
                          ),

                          SizedBox(height: 0.5.h),

                          // Body preview
                          Text(
                            notification["body"] as String,
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.onSurface
                                  .withValues(alpha: isRead ? 0.6 : 0.8),
                              fontWeight:
                                  isRead ? FontWeight.w400 : FontWeight.w500,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),

                          SizedBox(height: 1.h),

                          // Footer with timestamp and type
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    notification["senderName"] as String,
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall
                                        ?.copyWith(
                                      color: AppTheme
                                          .lightTheme.colorScheme.onSurface
                                          .withValues(alpha: 0.6),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(width: 2.w),
                                  Container(
                                    width: 1,
                                    height: 3.w,
                                    color: AppTheme.lightTheme.dividerColor,
                                  ),
                                  SizedBox(width: 2.w),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 2.w, vertical: 0.2.h),
                                    decoration: BoxDecoration(
                                      color: _getTypeColor(type)
                                          .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      _getTypeDisplayName(type),
                                      style: AppTheme
                                          .lightTheme.textTheme.bodySmall
                                          ?.copyWith(
                                        color: _getTypeColor(type),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 9.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                _formatRelativeTime(
                                    notification["timestamp"] as DateTime),
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurface
                                      .withValues(alpha: 0.5),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Action indicators (if any quick actions are available)
                if (_hasQuickActions(notification)) ...[
                  SizedBox(height: 1.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.touch_app,
                        size: 3.w,
                        color: AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.6),
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        "Ketuk untuk aksi",
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.6),
                          fontSize: 9.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'payment_reminder':
        return AppTheme.warningLight;
      case 'supervisor_message':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'system_alert':
        return AppTheme.lightTheme.colorScheme.secondary;
      case 'achievement':
        return AppTheme.accentLight;
      default:
        return AppTheme.lightTheme.colorScheme.onSurface;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'payment_reminder':
        return Icons.payment;
      case 'supervisor_message':
        return Icons.message;
      case 'system_alert':
        return Icons.info;
      case 'achievement':
        return Icons.emoji_events;
      default:
        return Icons.notifications;
    }
  }

  String _getTypeDisplayName(String type) {
    switch (type) {
      case 'payment_reminder':
        return 'Pengingat';
      case 'supervisor_message':
        return 'Pesan';
      case 'system_alert':
        return 'Sistem';
      case 'achievement':
        return 'Pencapaian';
      default:
        return 'Notifikasi';
    }
  }

  bool _hasQuickActions(Map<String, dynamic> notification) {
    final actionData = notification["actionData"] as Map<String, dynamic>?;
    return actionData != null && actionData["action"] != null;
  }

  String _formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return "${difference.inDays}h";
    } else if (difference.inHours > 0) {
      return "${difference.inHours}j";
    } else if (difference.inMinutes > 0) {
      return "${difference.inMinutes}m";
    } else {
      return "Baru";
    }
  }
}
