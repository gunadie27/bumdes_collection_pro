import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class PaymentTypeChartWidget extends StatelessWidget {
  final List<Map<String, dynamic>> paymentTypes;

  const PaymentTypeChartWidget({
    super.key,
    required this.paymentTypes,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Distribusi Jenis Pembayaran",
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Icon(
                Icons.pie_chart,
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 5.w,
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              // Pie Chart
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 20.h,
                  child: PieChart(
                    PieChartData(
                      sections: _getPieChartSections(),
                      centerSpaceRadius: 6.w,
                      sectionsSpace: 2,
                      startDegreeOffset: -90,
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          // Handle touch interaction if needed
                        },
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              // Legend
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: paymentTypes
                      .map((type) => _buildLegendItem(
                            type["type"] as String,
                            Color(type["color"] as int),
                            type["value"] as double,
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, double percentage) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        children: [
          Container(
            width: 3.w,
            height: 3.w,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "${percentage.toStringAsFixed(1)}%",
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _getPieChartSections() {
    return paymentTypes.map((type) {
      final color = Color(type["color"] as int);
      final value = type["value"] as double;

      return PieChartSectionData(
        color: color,
        value: value,
        title: "${value.toStringAsFixed(1)}%",
        radius: 8.w,
        titleStyle: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        titlePositionPercentageOffset: 0.6,
      );
    }).toList();
  }
}
