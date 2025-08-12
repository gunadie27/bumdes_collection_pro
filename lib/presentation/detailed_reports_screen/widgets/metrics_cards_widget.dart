import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class MetricsCardsWidget extends StatelessWidget {
  final double totalCollections;
  final double successRate;
  final String averageVisitTime;
  final double outstandingAmount;

  const MetricsCardsWidget({
    super.key,
    required this.totalCollections,
    required this.successRate,
    required this.averageVisitTime,
    required this.outstandingAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  'Total Terkumpul',
                  'Rp ${_formatCurrency(totalCollections)}',
                  Icons.account_balance_wallet,
                  AppTheme.successLight,
                  '+12%',
                  true,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildMetricCard(
                  'Tingkat Keberhasilan',
                  '${successRate.toStringAsFixed(1)}%',
                  Icons.trending_up,
                  AppTheme.lightTheme.colorScheme.primary,
                  '+5%',
                  true,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.w),
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  'Rata-rata Kunjungan',
                  averageVisitTime,
                  Icons.access_time,
                  AppTheme.warningLight,
                  '-2 min',
                  false,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildMetricCard(
                  'Tunggakan',
                  'Rp ${_formatCurrency(outstandingAmount)}',
                  Icons.warning,
                  AppTheme.errorLight,
                  '-8%',
                  false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    IconData icon,
    Color color,
    String trend,
    bool isPositive,
  ) {
    return Card(
      elevation: AppTheme.elevationLow,
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  icon,
                  color: color,
                  size: 6.w,
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: (isPositive
                            ? AppTheme.successLight
                            : AppTheme.errorLight)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isPositive ? Icons.trending_up : Icons.trending_down,
                        color: isPositive
                            ? AppTheme.successLight
                            : AppTheme.errorLight,
                        size: 3.w,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        trend,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: isPositive
                              ? AppTheme.successLight
                              : AppTheme.errorLight,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Text(
              value,
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.textTheme.bodySmall?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatCurrency(double amount) {
    if (amount >= 1000000000) {
      return '${(amount / 1000000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}jt';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}rb';
    } else {
      return amount.toStringAsFixed(0);
    }
  }
}
