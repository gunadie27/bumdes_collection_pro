import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ScheduledExportsWidget extends StatefulWidget {
  final VoidCallback onCreateSchedule;
  final Function(String scheduleId) onEditSchedule;
  final Function(String scheduleId) onDeleteSchedule;

  const ScheduledExportsWidget({
    Key? key,
    required this.onCreateSchedule,
    required this.onEditSchedule,
    required this.onDeleteSchedule,
  }) : super(key: key);

  @override
  State<ScheduledExportsWidget> createState() => _ScheduledExportsWidgetState();
}

class _ScheduledExportsWidgetState extends State<ScheduledExportsWidget> {
  // Mock scheduled exports data
  final List<Map<String, dynamic>> _scheduledExports = [
    {
      'id': 'SCH001',
      'name': 'Laporan Bulanan Penagihan',
      'category': 'collection_reports',
      'format': 'PDF',
      'frequency': 'monthly',
      'nextRun': DateTime(2024, 8, 1, 9, 0),
      'recipients': ['supervisor@bumdes.id', 'admin@bumdes.id'],
      'isActive': true,
    },
    {
      'id': 'SCH002',
      'name': 'Data Member Mingguan',
      'category': 'member_data',
      'format': 'Excel',
      'frequency': 'weekly',
      'nextRun': DateTime(2024, 7, 29, 8, 0),
      'recipients': ['admin@bumdes.id'],
      'isActive': true,
    },
    {
      'id': 'SCH003',
      'name': 'Analisis Performa Harian',
      'category': 'performance_analytics',
      'format': 'PDF',
      'frequency': 'daily',
      'nextRun': DateTime(2024, 7, 23, 7, 30),
      'recipients': ['manager@bumdes.id'],
      'isActive': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with Create Button
        Row(
          children: [
            CustomIconWidget(
              iconName: 'schedule',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 6.w,
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Text(
                "Ekspor Terjadwal",
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: widget.onCreateSchedule,
              icon: CustomIconWidget(
                iconName: 'add',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 4.w,
              ),
              label: Text("Buat Jadwal"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              ),
            ),
          ],
        ),

        SizedBox(height: 1.h),

        Text(
          "Otomatisasi laporan dengan pengiriman email",
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface
                .withValues(alpha: 0.7),
          ),
        ),

        SizedBox(height: 3.h),

        // Scheduled Exports List
        if (_scheduledExports.isEmpty)
          _buildEmptyState()
        else
          ..._scheduledExports
              .map((schedule) => _buildScheduleItem(schedule))
              .toList(),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Card(
      elevation: AppTheme.elevationLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: 'schedule',
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.3),
              size: 12.w,
            ),
            SizedBox(height: 2.h),
            Text(
              "Belum Ada Jadwal Ekspor",
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.7),
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              "Buat jadwal otomatis untuk laporan rutin",
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.5),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            ElevatedButton(
              onPressed: widget.onCreateSchedule,
              child: Text("Buat Jadwal Pertama"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleItem(Map<String, dynamic> schedule) {
    final isActive = schedule['isActive'] as bool;
    final nextRun = schedule['nextRun'] as DateTime;
    final recipients = schedule['recipients'] as List<String>;

    return Card(
      elevation: AppTheme.elevationLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        schedule['name'],
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        "${_getCategoryName(schedule['category'])} - ${schedule['format']}",
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: isActive,
                  onChanged: (value) => _toggleSchedule(schedule['id'], value),
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // Schedule Info
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    'schedule',
                    'Frekuensi',
                    _getFrequencyText(schedule['frequency']),
                  ),
                ),
                Expanded(
                  child: _buildInfoItem(
                    'access_time',
                    'Jadwal Berikutnya',
                    _formatDateTime(nextRun),
                  ),
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // Recipients
            _buildInfoItem(
              'email',
              'Penerima Email',
              recipients.join(', '),
            ),

            SizedBox(height: 2.h),

            // Status and Actions
            Row(
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppTheme.successLight.withValues(alpha: 0.1)
                        : AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 2.w,
                        height: 2.w,
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppTheme.successLight
                              : AppTheme.lightTheme.colorScheme.onSurface
                                  .withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        isActive ? 'Aktif' : 'Nonaktif',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: isActive
                              ? AppTheme.successLight
                              : AppTheme.lightTheme.colorScheme.onSurface
                                  .withValues(alpha: 0.7),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => widget.onEditSchedule(schedule['id']),
                  icon: CustomIconWidget(
                    iconName: 'edit',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 5.w,
                  ),
                ),
                IconButton(
                  onPressed: () =>
                      _confirmDelete(schedule['id'], schedule['name']),
                  icon: CustomIconWidget(
                    iconName: 'delete',
                    color: AppTheme.lightTheme.colorScheme.error,
                    size: 5.w,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomIconWidget(
          iconName: icon,
          color: AppTheme.lightTheme.colorScheme.primary,
          size: 4.w,
        ),
        SizedBox(width: 2.w),
        Expanded(
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
              Text(
                value,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _toggleSchedule(String scheduleId, bool isActive) {
    setState(() {
      final index = _scheduledExports.indexWhere((s) => s['id'] == scheduleId);
      if (index != -1) {
        _scheduledExports[index]['isActive'] = isActive;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isActive ? "Jadwal diaktifkan" : "Jadwal dinonaktifkan"),
        backgroundColor:
            isActive ? AppTheme.successLight : AppTheme.warningLight,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        ),
      ),
    );
  }

  void _confirmDelete(String scheduleId, String scheduleName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Hapus Jadwal"),
        content:
            Text("Apakah Anda yakin ingin menghapus jadwal '$scheduleName'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteSchedule(scheduleId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: Text("Hapus"),
          ),
        ],
      ),
    );
  }

  void _deleteSchedule(String scheduleId) {
    setState(() {
      _scheduledExports.removeWhere((s) => s['id'] == scheduleId);
    });

    widget.onDeleteSchedule(scheduleId);
  }

  String _getCategoryName(String category) {
    switch (category) {
      case 'collection_reports':
        return 'Laporan Penagihan';
      case 'performance_analytics':
        return 'Analisis Performa';
      case 'member_data':
        return 'Data Member';
      case 'financial_summaries':
        return 'Ringkasan Keuangan';
      default:
        return category;
    }
  }

  String _getFrequencyText(String frequency) {
    switch (frequency) {
      case 'daily':
        return 'Harian';
      case 'weekly':
        return 'Mingguan';
      case 'monthly':
        return 'Bulanan';
      case 'quarterly':
        return 'Triwulan';
      default:
        return frequency;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return "${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
  }
}
