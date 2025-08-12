import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class PerformanceSummaryWidget extends StatelessWidget {
  final Map<String, dynamic> performanceData;

  const PerformanceSummaryWidget({
    super.key,
    required this.performanceData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Text(
              "Performa Bulan Ini",
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  "Kunjungan",
                  performanceData["collections"]?.toString() ?? "0",
                  Icons.location_on,
                  AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: _buildMetricCard(
                  "Tingkat Keberhasilan",
                  "${performanceData["successRate"]?.toStringAsFixed(1) ?? "0.0"}%",
                  Icons.check_circle,
                  AppTheme.successLight,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.w),
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  "Rata-rata Waktu Kunjungan",
                  "${performanceData["avgVisitTime"] ?? "0"} menit",
                  Icons.schedule,
                  AppTheme.warningLight,
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: _buildMetricCard(
                  "Ranking Tim",
                  "#${performanceData["ranking"] ?? "N/A"}",
                  Icons.emoji_events,
                  AppTheme.accentLight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                color: color,
                size: 5.w,
              ),
              Container(
                padding: EdgeInsets.all(1.w),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.trending_up,
                  color: color,
                  size: 3.w,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.7),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
