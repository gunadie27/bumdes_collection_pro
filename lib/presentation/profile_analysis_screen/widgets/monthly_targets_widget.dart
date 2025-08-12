import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class MonthlyTargetsWidget extends StatelessWidget {
  final Map<String, dynamic> targetData;

  const MonthlyTargetsWidget({
    super.key,
    required this.targetData,
  });

  @override
  Widget build(BuildContext context) {
    final target = targetData["target"] as int? ?? 0;
    final achieved = targetData["achieved"] as int? ?? 0;
    final remaining = targetData["remaining"] as int? ?? 0;
    final daysLeft = targetData["daysLeft"] as int? ?? 0;
    final progressPercentage =
        targetData["progressPercentage"] as double? ?? 0.0;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Target Bulanan",
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: _getStatusColor(progressPercentage)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getStatusIcon(progressPercentage),
                      color: _getStatusColor(progressPercentage),
                      size: 3.w,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      "${progressPercentage.toStringAsFixed(1)}%",
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: _getStatusColor(progressPercentage),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Progress Bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Progress",
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "$achieved / $target",
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progressPercentage / 100,
                  backgroundColor: AppTheme.lightTheme.dividerColor,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getStatusColor(progressPercentage),
                  ),
                  minHeight: 1.h,
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Statistics Row
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  "Tercapai",
                  achieved.toString(),
                  Icons.check_circle_outline,
                  AppTheme.successLight,
                ),
              ),
              Container(
                width: 1,
                height: 5.h,
                color: AppTheme.lightTheme.dividerColor,
                margin: EdgeInsets.symmetric(horizontal: 4.w),
              ),
              Expanded(
                child: _buildStatItem(
                  "Sisa Target",
                  remaining.toString(),
                  Icons.radio_button_unchecked,
                  AppTheme.warningLight,
                ),
              ),
              Container(
                width: 1,
                height: 5.h,
                color: AppTheme.lightTheme.dividerColor,
                margin: EdgeInsets.symmetric(horizontal: 4.w),
              ),
              Expanded(
                child: _buildStatItem(
                  "Hari Tersisa",
                  daysLeft.toString(),
                  Icons.calendar_today,
                  AppTheme.lightTheme.colorScheme.secondary,
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Motivation Message
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color:
                  _getStatusColor(progressPercentage).withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              border: Border.all(
                color:
                    _getStatusColor(progressPercentage).withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: _getStatusColor(progressPercentage),
                  size: 4.w,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    _getMotivationMessage(
                        progressPercentage, remaining, daysLeft),
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: _getStatusColor(progressPercentage),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 5.w,
        ),
        SizedBox(height: 0.5.h),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface
                .withValues(alpha: 0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Color _getStatusColor(double percentage) {
    if (percentage >= 80) {
      return AppTheme.successLight;
    } else if (percentage >= 60) {
      return AppTheme.warningLight;
    } else {
      return AppTheme.errorLight;
    }
  }

  IconData _getStatusIcon(double percentage) {
    if (percentage >= 80) {
      return Icons.trending_up;
    } else if (percentage >= 60) {
      return Icons.trending_flat;
    } else {
      return Icons.trending_down;
    }
  }

  String _getMotivationMessage(double percentage, int remaining, int daysLeft) {
    if (percentage >= 100) {
      return "Fantastis! Anda telah mencapai target bulanan. Pertahankan performa hebat ini!";
    } else if (percentage >= 80) {
      return "Hebat! Anda hampir mencapai target. Hanya $remaining kunjungan lagi!";
    } else if (percentage >= 60) {
      return "Bagus! Anda di jalur yang tepat. Tingkatkan sedikit lagi untuk mencapai target.";
    } else if (daysLeft > 0) {
      return "Semangat! Masih ada $daysLeft hari untuk mencapai target. Anda pasti bisa!";
    } else {
      return "Jangan menyerah! Setiap kunjungan adalah langkah menuju kesuksesan.";
    }
  }
}
