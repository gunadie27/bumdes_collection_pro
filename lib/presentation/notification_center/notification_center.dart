import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../core/app_export.dart';
import './widgets/notification_list_widget.dart';
import './widgets/notification_search_widget.dart';
import './widgets/notification_settings_widget.dart';
import './widgets/notification_tabs_widget.dart';

class NotificationCenter extends StatefulWidget {
  const NotificationCenter({super.key});

  @override
  State<NotificationCenter> createState() => _NotificationCenterState();
}

class _NotificationCenterState extends State<NotificationCenter>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  bool _isSearching = false;
  String _searchQuery = '';
  List<Map<String, dynamic>> _selectedNotifications = [];

  // Mock notification data
  final List<Map<String, dynamic>> _allNotifications = [
    {
      "id": "NOT001",
      "type": "payment_reminder",
      "title": "Reminder Pembayaran Cicilan",
      "body":
          "Siti Nurhaliza memiliki cicilan yang jatuh tempo dalam 2 hari. Kunjungan diperlukan.",
      "senderAvatar":
          "https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&w=400",
      "senderName": "System",
      "timestamp": DateTime(2024, 7, 22, 14, 30),
      "isRead": false,
      "isImportant": true,
      "category": "payment_reminder",
      "relatedMemberId": "BUM001234",
      "actionData": {
        "action": "visit_member",
        "memberId": "BUM001234",
        "memberName": "Siti Nurhaliza"
      }
    },
    {
      "id": "NOT002",
      "type": "supervisor_message",
      "title": "Pesan dari Supervisor",
      "body": "Target bulanan hampir tercapai. Lanjutkan kinerja yang baik!",
      "senderAvatar":
          "https://images.pexels.com/photos/1040880/pexels-photo-1040880.jpeg?auto=compress&cs=tinysrgb&w=400",
      "senderName": "Ahmad Supervisor",
      "timestamp": DateTime(2024, 7, 22, 10, 15),
      "isRead": true,
      "isImportant": false,
      "category": "supervisor_message",
      "actionData": {"action": "reply_message", "messageId": "MSG001"}
    },
    {
      "id": "NOT003",
      "type": "system_alert",
      "title": "Update Sistem",
      "body":
          "Aplikasi telah diperbarui ke versi terbaru. Fitur baru tersedia.",
      "senderAvatar": "",
      "senderName": "System",
      "timestamp": DateTime(2024, 7, 21, 16, 45),
      "isRead": true,
      "isImportant": false,
      "category": "system_alert",
      "actionData": {"action": "view_changelog"}
    },
    {
      "id": "NOT004",
      "type": "achievement",
      "title": "Pencapaian Baru!",
      "body": "Selamat! Anda telah mencapai target 20 kunjungan minggu ini.",
      "senderAvatar": "",
      "senderName": "System",
      "timestamp": DateTime(2024, 7, 21, 18, 20),
      "isRead": false,
      "isImportant": true,
      "category": "achievement",
      "actionData": {"action": "view_achievement", "achievementId": "ACH002"}
    },
    {
      "id": "NOT005",
      "type": "payment_reminder",
      "title": "Pengingat Kunjungan Ulang",
      "body":
          "Budi Santoso belum melakukan pembayaran. Kunjungan ulang diperlukan.",
      "senderAvatar":
          "https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&w=400",
      "senderName": "System",
      "timestamp": DateTime(2024, 7, 21, 9, 30),
      "isRead": false,
      "isImportant": true,
      "category": "payment_reminder",
      "relatedMemberId": "BUM001235",
      "actionData": {
        "action": "visit_member",
        "memberId": "BUM001235",
        "memberName": "Budi Santoso"
      }
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // Search Bar
          if (_isSearching) ...[
            NotificationSearchWidget(
              onSearchChanged: _handleSearchChanged,
              onSearchClosed: () {
                setState(() {
                  _isSearching = false;
                  _searchQuery = '';
                });
              },
            ),
          ],

          // Tab Bar
          NotificationTabsWidget(
            tabController: _tabController,
            unreadCount: _getUnreadCount(),
            importantCount: _getImportantCount(),
          ),

          // Bulk Actions Bar (shown when notifications are selected)
          if (_selectedNotifications.isNotEmpty) ...[
            _buildBulkActionsBar(),
          ],

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // All Notifications Tab
                NotificationListWidget(
                  notifications: _getFilteredNotifications('all'),
                  selectedNotifications: _selectedNotifications,
                  onNotificationTap: _handleNotificationTap,
                  onNotificationLongPress: _handleNotificationLongPress,
                  onNotificationSelected: _handleNotificationSelected,
                  onRefresh: _handleRefresh,
                ),

                // Unread Notifications Tab
                NotificationListWidget(
                  notifications: _getFilteredNotifications('unread'),
                  selectedNotifications: _selectedNotifications,
                  onNotificationTap: _handleNotificationTap,
                  onNotificationLongPress: _handleNotificationLongPress,
                  onNotificationSelected: _handleNotificationSelected,
                  onRefresh: _handleRefresh,
                ),

                // Important Notifications Tab
                NotificationListWidget(
                  notifications: _getFilteredNotifications('important'),
                  selectedNotifications: _selectedNotifications,
                  onNotificationTap: _handleNotificationTap,
                  onNotificationLongPress: _handleNotificationLongPress,
                  onNotificationSelected: _handleNotificationSelected,
                  onRefresh: _handleRefresh,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
      elevation: AppTheme.elevationLow,
      centerTitle: true,
      leading: IconButton(
        icon: CustomIconWidget(
          iconName: 'arrow_back',
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          size: 6.w,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              "Pusat Notifikasi",
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (_getUnreadCount() > 0) ...[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: AppTheme.errorLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "${_getUnreadCount()}",
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
      actions: [
        IconButton(
          icon: CustomIconWidget(
            iconName: _isSearching ? 'close' : 'search',
            color: AppTheme.lightTheme.colorScheme.onPrimary,
            size: 6.w,
          ),
          onPressed: () {
            setState(() {
              _isSearching = !_isSearching;
              if (!_isSearching) {
                _searchQuery = '';
              }
            });
          },
        ),
        IconButton(
          icon: CustomIconWidget(
            iconName: 'settings',
            color: AppTheme.lightTheme.colorScheme.onPrimary,
            size: 6.w,
          ),
          onPressed: _showNotificationSettings,
        ),
      ],
    );
  }

  Widget _buildBulkActionsBar() {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
        border: Border(
          bottom: BorderSide(
            color: AppTheme.lightTheme.dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            "${_selectedNotifications.length} dipilih",
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          TextButton.icon(
            onPressed: _markSelectedAsRead,
            icon: Icon(
              Icons.mark_email_read,
              size: 4.w,
            ),
            label: Text("Tandai Dibaca"),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
          SizedBox(width: 2.w),
          TextButton.icon(
            onPressed: _deleteSelectedNotifications,
            icon: Icon(
              Icons.delete_outline,
              size: 4.w,
            ),
            label: Text("Hapus"),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.errorLight,
            ),
          ),
          SizedBox(width: 2.w),
          IconButton(
            onPressed: () {
              setState(() {
                _selectedNotifications.clear();
              });
            },
            icon: Icon(
              Icons.close,
              size: 5.w,
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredNotifications(String filter) {
    List<Map<String, dynamic>> filtered = List.from(_allNotifications);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((notification) {
        final title = (notification["title"] as String).toLowerCase();
        final body = (notification["body"] as String).toLowerCase();
        final query = _searchQuery.toLowerCase();
        return title.contains(query) || body.contains(query);
      }).toList();
    }

    // Apply tab filter
    switch (filter) {
      case 'unread':
        filtered = filtered.where((n) => !(n["isRead"] as bool)).toList();
        break;
      case 'important':
        filtered = filtered.where((n) => n["isImportant"] as bool).toList();
        break;
      default:
        // 'all' - no additional filtering needed
        break;
    }

    // Sort by timestamp (newest first)
    filtered.sort((a, b) =>
        (b["timestamp"] as DateTime).compareTo(a["timestamp"] as DateTime));

    return filtered;
  }

  int _getUnreadCount() {
    return _allNotifications.where((n) => !(n["isRead"] as bool)).length;
  }

  int _getImportantCount() {
    return _allNotifications.where((n) => n["isImportant"] as bool).length;
  }

  void _handleSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _handleNotificationTap(Map<String, dynamic> notification) {
    if (_selectedNotifications.isNotEmpty) {
      // If in selection mode, toggle selection
      _handleNotificationSelected(notification);
    } else {
      // Normal tap - expand notification and mark as read
      _expandNotification(notification);
      if (!(notification["isRead"] as bool)) {
        _markNotificationAsRead(notification);
      }
    }
  }

  void _handleNotificationLongPress(Map<String, dynamic> notification) {
    _handleNotificationSelected(notification);
  }

  void _handleNotificationSelected(Map<String, dynamic> notification) {
    setState(() {
      if (_selectedNotifications.any((n) => n["id"] == notification["id"])) {
        _selectedNotifications
            .removeWhere((n) => n["id"] == notification["id"]);
      } else {
        _selectedNotifications.add(notification);
      }
    });
  }

  void _expandNotification(Map<String, dynamic> notification) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppTheme.radiusLarge),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        builder: (context, scrollController) => Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            children: [
              Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 2.h),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Notification header
                      Row(
                        children: [
                          if ((notification["senderAvatar"] as String)
                              .isNotEmpty) ...[
                            CircleAvatar(
                              radius: 6.w,
                              backgroundImage: CachedNetworkImageProvider(
                                notification["senderAvatar"] as String,
                              ),
                            ),
                            SizedBox(width: 3.w),
                          ],
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  notification["title"] as String,
                                  style: AppTheme
                                      .lightTheme.textTheme.titleMedium
                                      ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  "dari ${notification["senderName"] as String}",
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color: AppTheme
                                        .lightTheme.colorScheme.onSurface
                                        .withValues(alpha: 0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),

                      // Notification body
                      Text(
                        notification["body"] as String,
                        style: AppTheme.lightTheme.textTheme.bodyMedium,
                      ),

                      SizedBox(height: 2.h),

                      // Timestamp
                      Text(
                        _formatDateTime(notification["timestamp"] as DateTime),
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.5),
                        ),
                      ),

                      // Action buttons based on notification type
                      if (notification["actionData"] != null) ...[
                        SizedBox(height: 3.h),
                        _buildActionButtons(
                            notification["actionData"] as Map<String, dynamic>),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(Map<String, dynamic> actionData) {
    final action = actionData["action"] as String;

    switch (action) {
      case 'visit_member':
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to member detail
              Navigator.pushNamed(
                context,
                '/member-detail-screen',
                arguments: {
                  'memberId': actionData["memberId"],
                },
              );
            },
            icon: Icon(Icons.location_on),
            label: Text("Kunjungi ${actionData["memberName"]}"),
          ),
        );

      case 'reply_message':
        return Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  // Implement reply functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text("Fitur balas pesan akan segera tersedia")),
                  );
                },
                icon: Icon(Icons.reply),
                label: Text("Balas"),
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  // View full conversation
                },
                icon: Icon(Icons.chat),
                label: Text("Lihat Detail"),
              ),
            ),
          ],
        );

      default:
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Tutup"),
          ),
        );
    }
  }

  void _markNotificationAsRead(Map<String, dynamic> notification) {
    setState(() {
      notification["isRead"] = true;
    });
  }

  void _markSelectedAsRead() {
    setState(() {
      for (var notification in _selectedNotifications) {
        notification["isRead"] = true;
      }
      _selectedNotifications.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Notifikasi berhasil ditandai sebagai dibaca"),
        backgroundColor: AppTheme.successLight,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _deleteSelectedNotifications() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Hapus Notifikasi"),
        content: Text(
            "Apakah Anda yakin ingin menghapus ${_selectedNotifications.length} notifikasi yang dipilih?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                for (var selected in _selectedNotifications) {
                  _allNotifications
                      .removeWhere((n) => n["id"] == selected["id"]);
                }
                _selectedNotifications.clear();
              });
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Notifikasi berhasil dihapus"),
                  backgroundColor: AppTheme.successLight,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorLight,
            ),
            child: Text("Hapus"),
          ),
        ],
      ),
    );
  }

  Future<void> _handleRefresh() async {
    setState(() => _isLoading = true);

    // Simulate API call to refresh notifications
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Notifikasi berhasil diperbarui"),
        backgroundColor: AppTheme.successLight,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showNotificationSettings() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppTheme.radiusLarge),
        ),
      ),
      builder: (context) => NotificationSettingsWidget(),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return "${difference.inDays} hari yang lalu";
    } else if (difference.inHours > 0) {
      return "${difference.inHours} jam yang lalu";
    } else if (difference.inMinutes > 0) {
      return "${difference.inMinutes} menit yang lalu";
    } else {
      return "Baru saja";
    }
  }
}