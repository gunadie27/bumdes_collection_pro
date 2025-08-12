import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DateRangePickerWidget extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;
  final Function(DateTime, DateTime) onDateRangeChanged;

  const DateRangePickerWidget({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.onDateRangeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      color: AppTheme.lightTheme.colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Periode Laporan',
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),
          SizedBox(height: 2.h),

          // Preset Options
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildPresetChip(
                  'Hari Ini',
                  () => _selectPreset(context, PresetRange.today),
                  context,
                ),
                SizedBox(width: 2.w),
                _buildPresetChip(
                  'Minggu Ini',
                  () => _selectPreset(context, PresetRange.thisWeek),
                  context,
                ),
                SizedBox(width: 2.w),
                _buildPresetChip(
                  'Bulan Ini',
                  () => _selectPreset(context, PresetRange.thisMonth),
                  context,
                ),
                SizedBox(width: 2.w),
                _buildPresetChip(
                  'Kuartal',
                  () => _selectPreset(context, PresetRange.thisQuarter),
                  context,
                ),
                SizedBox(width: 2.w),
                _buildPresetChip(
                  'Kustom',
                  () => _selectCustomRange(context),
                  context,
                ),
              ],
            ),
          ),

          SizedBox(height: 2.h),

          // Current Range Display
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primaryContainer
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'calendar_today',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 5.w,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    '${_formatDate(startDate)} - ${_formatDate(endDate)}',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                IconButton(
                  icon: CustomIconWidget(
                    iconName: 'edit',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 5.w,
                  ),
                  onPressed: () => _selectCustomRange(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPresetChip(
      String label, VoidCallback onTap, BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  void _selectPreset(BuildContext context, PresetRange preset) {
    DateTime start, end;
    final now = DateTime.now();

    switch (preset) {
      case PresetRange.today:
        start = DateTime(now.year, now.month, now.day);
        end = DateTime(now.year, now.month, now.day, 23, 59, 59);
        break;
      case PresetRange.thisWeek:
        final weekDay = now.weekday;
        start = now.subtract(Duration(days: weekDay - 1));
        start = DateTime(start.year, start.month, start.day);
        end = DateTime(now.year, now.month, now.day, 23, 59, 59);
        break;
      case PresetRange.thisMonth:
        start = DateTime(now.year, now.month, 1);
        end = DateTime(now.year, now.month, now.day, 23, 59, 59);
        break;
      case PresetRange.thisQuarter:
        final quarter = (now.month - 1) ~/ 3;
        start = DateTime(now.year, quarter * 3 + 1, 1);
        end = DateTime(now.year, now.month, now.day, 23, 59, 59);
        break;
    }

    onDateRangeChanged(start, end);
  }

  Future<void> _selectCustomRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: startDate, end: endDate),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: AppTheme.lightTheme.colorScheme,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      onDateRangeChanged(picked.start, picked.end);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

enum PresetRange {
  today,
  thisWeek,
  thisMonth,
  thisQuarter,
}
