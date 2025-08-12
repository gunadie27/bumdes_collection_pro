import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DateRangeSelectorWidget extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;
  final String selectedPreset;
  final Function(DateTime start, DateTime end, String preset)
      onDateRangeChanged;

  const DateRangeSelectorWidget({
    Key? key,
    required this.startDate,
    required this.endDate,
    required this.selectedPreset,
    required this.onDateRangeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'date_range',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 5.w,
                ),
                SizedBox(width: 2.w),
                Text(
                  "Rentang Tanggal",
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // Preset Options
            Wrap(
              spacing: 2.w,
              runSpacing: 1.h,
              children: [
                _buildPresetChip(context, 'daily', 'Harian'),
                _buildPresetChip(context, 'weekly', 'Mingguan'),
                _buildPresetChip(context, 'monthly', 'Bulanan'),
                _buildPresetChip(context, 'quarterly', 'Triwulan'),
                _buildPresetChip(context, 'custom', 'Kustom'),
              ],
            ),

            SizedBox(height: 2.h),

            // Date Selection
            Row(
              children: [
                Expanded(
                  child: _buildDateField(
                    context,
                    "Dari",
                    startDate,
                    (date) => _updateDateRange(date, endDate),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: _buildDateField(
                    context,
                    "Sampai",
                    endDate,
                    (date) => _updateDateRange(startDate, date),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPresetChip(BuildContext context, String preset, String label) {
    final isSelected = selectedPreset == preset;

    return GestureDetector(
      onTap: () => _selectPreset(preset),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightTheme.colorScheme.primary
              : AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          border: Border.all(
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.dividerColor,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.onPrimary
                : AppTheme.lightTheme.colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildDateField(BuildContext context, String label, DateTime date,
      Function(DateTime) onSelect) {
    return GestureDetector(
      onTap: () => _selectDate(context, date, onSelect),
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.lightTheme.dividerColor),
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
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
            Text(
              _formatDate(date),
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectPreset(String preset) {
    DateTime start, end;
    final now = DateTime.now();

    switch (preset) {
      case 'daily':
        start = DateTime(now.year, now.month, now.day);
        end = start.add(const Duration(days: 1));
        break;
      case 'weekly':
        start = now.subtract(Duration(days: now.weekday - 1));
        end = start.add(const Duration(days: 7));
        break;
      case 'monthly':
        start = DateTime(now.year, now.month, 1);
        end = DateTime(now.year, now.month + 1, 1);
        break;
      case 'quarterly':
        final quarter = ((now.month - 1) / 3).floor();
        start = DateTime(now.year, quarter * 3 + 1, 1);
        end = DateTime(now.year, quarter * 3 + 4, 1);
        break;
      case 'custom':
        return; // Don't update dates for custom preset
      default:
        return;
    }

    onDateRangeChanged(start, end, preset);
  }

  Future<void> _selectDate(BuildContext context, DateTime initialDate,
      Function(DateTime) onSelect) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppTheme.lightTheme.colorScheme.primary,
                ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      onSelect(picked);
    }
  }

  void _updateDateRange(DateTime start, DateTime end) {
    onDateRangeChanged(start, end, 'custom');
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }
}
