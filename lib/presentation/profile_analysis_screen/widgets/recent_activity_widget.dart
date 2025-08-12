import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class RecentActivityWidget extends StatelessWidget {
  final List<Map<String, dynamic>> activities;
  final Function(Map<String, dynamic>) onViewDetail;

  const RecentActivityWidget({
    super.key,
    required this.activities,
    required this.onViewDetail,
  });

  @override
  Widget build(BuildContext context) {
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
                "Aktivitas Terbaru",
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "${activities.length} kunjungan terakhir",
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.7),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Activity Timeline
          ...activities.asMap().entries.map((entry) {
            final index = entry.key;
            final activity = entry.value;
            final isLast = index == activities.length - 1;

            return _buildActivityItem(activity, isLast);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildActivityItem(Map<String, dynamic> activity, bool isLast) {
    final outcome = activity["outcome"] as String;
    final amount = activity["amount"] as double;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline indicator
        Column(
          children: [
            Container(
              width: 3.w,
              height: 3.w,
              decoration: BoxDecoration(
                color: _getOutcomeColor(outcome),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.lightTheme.cardColor,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _getOutcomeColor(outcome).withValues(alpha: 0.3),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
            if (!isLast) ...[
              Container(
                width: 1,
                height: 6.h,
                color: AppTheme.lightTheme.dividerColor,
                margin: EdgeInsets.symmetric(vertical: 0.5.h),
              ),
            ],
          ],
        ),

        SizedBox(width: 3.w),

        // Activity content
        Expanded(
          child: GestureDetector(
            onTap: () => onViewDetail(activity),
            child: Container(
              padding: EdgeInsets.all(3.w),
              margin: EdgeInsets.only(bottom: isLast ? 0 : 2.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                border: Border.all(
                  color:
                      AppTheme.lightTheme.dividerColor.withValues(alpha: 0.5),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header row with member name and outcome
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          activity["memberName"] as String,
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color:
                              _getOutcomeColor(outcome).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _getOutcomeText(outcome),
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: _getOutcomeColor(outcome),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 0.5.h),

                  // Amount and time row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        amount > 0
                            ? _formatCurrency(amount)
                            : "Tidak ada pembayaran",
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: amount > 0
                              ? AppTheme.successLight
                              : AppTheme.lightTheme.colorScheme.onSurface
                                  .withValues(alpha: 0.7),
                          fontWeight:
                              amount > 0 ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                      Text(
                        _formatTime(activity["date"] as DateTime),
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),

                  // Note
                  if (activity["note"] != null &&
                      (activity["note"] as String).isNotEmpty) ...[
                    SizedBox(height: 0.5.h),
                    Text(
                      activity["note"] as String,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.7),
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _getOutcomeColor(String outcome) {
    switch (outcome) {
      case 'success':
        return AppTheme.successLight;
      case 'partial':
        return AppTheme.warningLight;
      case 'no_payment':
        return AppTheme.lightTheme.colorScheme.secondary;
      default:
        return AppTheme.lightTheme.colorScheme.onSurface;
    }
  }

  String _getOutcomeText(String outcome) {
    switch (outcome) {
      case 'success':
        return 'Berhasil';
      case 'partial':
        return 'Sebagian';
      case 'no_payment':
        return 'Tidak Bayar';
      default:
        return 'Tidak Diketahui';
    }
  }

  String _formatCurrency(double amount) {
    return "Rp ${amount.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        )},00";
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return "${difference.inDays}h yang lalu";
    } else if (difference.inHours > 0) {
      return "${difference.inHours}j yang lalu";
    } else if (difference.inMinutes > 0) {
      return "${difference.inMinutes}m yang lalu";
    } else {
      return "Baru saja";
    }
  }
}
