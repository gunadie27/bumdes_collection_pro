import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class NotificationSettingsWidget extends StatefulWidget {
  const NotificationSettingsWidget({super.key});

  @override
  State<NotificationSettingsWidget> createState() =>
      _NotificationSettingsWidgetState();
}

class _NotificationSettingsWidgetState
    extends State<NotificationSettingsWidget> {
  // Mock notification preferences
  bool _pushNotificationsEnabled = true;
  bool _paymentRemindersEnabled = true;
  bool _supervisorMessagesEnabled = true;
  bool _systemAlertsEnabled = true;
  bool _achievementNotificationsEnabled = true;
  bool _quietHoursEnabled = false;
  TimeOfDay _quietHoursStart = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay _quietHoursEnd = const TimeOfDay(hour: 6, minute: 0);
  String _priorityLevel = 'medium';

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      maxChildSize: 0.95,
      minChildSize: 0.6,
      builder: (context, scrollController) => Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppTheme.radiusLarge),
          ),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            SizedBox(height: 2.h),

            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Pengaturan Notifikasi",
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close,
                    size: 6.w,
                  ),
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // Settings content
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Main notifications toggle
                    _buildSectionHeader("Notifikasi Push"),
                    _buildSwitchTile(
                      title: "Aktifkan Notifikasi Push",
                      subtitle: "Terima notifikasi secara real-time",
                      value: _pushNotificationsEnabled,
                      onChanged: (value) {
                        setState(() {
                          _pushNotificationsEnabled = value;
                        });
                      },
                      icon: Icons.notifications,
                    ),

                    SizedBox(height: 3.h),

                    // Notification categories
                    _buildSectionHeader("Kategori Notifikasi"),

                    _buildSwitchTile(
                      title: "Pengingat Pembayaran",
                      subtitle: "Notifikasi untuk cicilan jatuh tempo",
                      value:
                          _paymentRemindersEnabled && _pushNotificationsEnabled,
                      onChanged: _pushNotificationsEnabled
                          ? (value) {
                              setState(() {
                                _paymentRemindersEnabled = value;
                              });
                            }
                          : null,
                      icon: Icons.payment,
                      iconColor: AppTheme.warningLight,
                    ),

                    _buildSwitchTile(
                      title: "Pesan Supervisor",
                      subtitle: "Pesan dari supervisor dan tim",
                      value: _supervisorMessagesEnabled &&
                          _pushNotificationsEnabled,
                      onChanged: _pushNotificationsEnabled
                          ? (value) {
                              setState(() {
                                _supervisorMessagesEnabled = value;
                              });
                            }
                          : null,
                      icon: Icons.message,
                      iconColor: AppTheme.lightTheme.colorScheme.primary,
                    ),

                    _buildSwitchTile(
                      title: "Alert Sistem",
                      subtitle: "Pembaruan aplikasi dan sistem",
                      value: _systemAlertsEnabled && _pushNotificationsEnabled,
                      onChanged: _pushNotificationsEnabled
                          ? (value) {
                              setState(() {
                                _systemAlertsEnabled = value;
                              });
                            }
                          : null,
                      icon: Icons.info,
                      iconColor: AppTheme.lightTheme.colorScheme.secondary,
                    ),

                    _buildSwitchTile(
                      title: "Notifikasi Pencapaian",
                      subtitle: "Badge dan pencapaian baru",
                      value: _achievementNotificationsEnabled &&
                          _pushNotificationsEnabled,
                      onChanged: _pushNotificationsEnabled
                          ? (value) {
                              setState(() {
                                _achievementNotificationsEnabled = value;
                              });
                            }
                          : null,
                      icon: Icons.emoji_events,
                      iconColor: AppTheme.accentLight,
                    ),

                    SizedBox(height: 3.h),

                    // Quiet hours
                    _buildSectionHeader("Jam Tenang"),
                    _buildSwitchTile(
                      title: "Aktifkan Jam Tenang",
                      subtitle: "Tidak ada notifikasi pada jam tertentu",
                      value: _quietHoursEnabled && _pushNotificationsEnabled,
                      onChanged: _pushNotificationsEnabled
                          ? (value) {
                              setState(() {
                                _quietHoursEnabled = value;
                              });
                            }
                          : null,
                      icon: Icons.bedtime,
                      iconColor: AppTheme.lightTheme.colorScheme.secondary,
                    ),

                    if (_quietHoursEnabled && _pushNotificationsEnabled) ...[
                      SizedBox(height: 1.h),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 4.w),
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildTimePicker(
                                "Mulai",
                                _quietHoursStart,
                                (time) =>
                                    setState(() => _quietHoursStart = time),
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Expanded(
                              child: _buildTimePicker(
                                "Selesai",
                                _quietHoursEnd,
                                (time) => setState(() => _quietHoursEnd = time),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    SizedBox(height: 3.h),

                    // Priority settings
                    _buildSectionHeader("Tingkat Prioritas"),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.cardColor,
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusMedium),
                        border: Border.all(
                          color: AppTheme.lightTheme.dividerColor,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          _buildPriorityOption(
                            "Tinggi",
                            "Semua notifikasi dengan suara dan getaran",
                            "high",
                          ),
                          _buildPriorityOption(
                            "Sedang",
                            "Notifikasi penting saja dengan suara",
                            "medium",
                          ),
                          _buildPriorityOption(
                            "Rendah",
                            "Hanya notifikasi visual tanpa suara",
                            "low",
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 2.h),
                  ],
                ),
              ),
            ),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Reset to default settings
                      setState(() {
                        _pushNotificationsEnabled = true;
                        _paymentRemindersEnabled = true;
                        _supervisorMessagesEnabled = true;
                        _systemAlertsEnabled = true;
                        _achievementNotificationsEnabled = true;
                        _quietHoursEnabled = false;
                        _priorityLevel = 'medium';
                      });
                    },
                    child: Text("Reset"),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Save settings
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Pengaturan notifikasi disimpan"),
                          backgroundColor: AppTheme.successLight,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    child: Text("Simpan"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Text(
        title,
        style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: AppTheme.lightTheme.colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool)? onChanged,
    required IconData icon,
    Color? iconColor,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
      child: SwitchListTile(
        title: Text(
          title,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: onChanged != null
                ? AppTheme.lightTheme.colorScheme.onSurface
                : AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.5),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: onChanged != null
                ? AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.7)
                : AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.4),
          ),
        ),
        secondary: Icon(
          icon,
          color: onChanged != null
              ? (iconColor ?? AppTheme.lightTheme.colorScheme.primary)
              : AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.4),
          size: 6.w,
        ),
        value: value,
        onChanged: onChanged,
        activeColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  Widget _buildTimePicker(
      String label, TimeOfDay time, Function(TimeOfDay) onChanged) {
    return GestureDetector(
      onTap: () async {
        final pickedTime = await showTimePicker(
          context: context,
          initialTime: time,
        );
        if (pickedTime != null) {
          onChanged(pickedTime);
        }
      },
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.cardColor,
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          border: Border.all(
            color: AppTheme.lightTheme.dividerColor,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.7),
              ),
            ),
            SizedBox(height: 0.5.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}",
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(
                  Icons.access_time,
                  size: 4.w,
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityOption(String title, String description, String value) {
    final isSelected = _priorityLevel == value;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 0.5.h),
      child: RadioListTile<String>(
        title: Text(
          title,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
        subtitle: Text(
          description,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface
                .withValues(alpha: 0.7),
          ),
        ),
        value: value,
        groupValue: _priorityLevel,
        onChanged: (newValue) {
          if (newValue != null) {
            setState(() {
              _priorityLevel = newValue;
            });
          }
        },
        activeColor: AppTheme.lightTheme.colorScheme.primary,
        controlAffinity: ListTileControlAffinity.trailing,
      ),
    );
  }
}
