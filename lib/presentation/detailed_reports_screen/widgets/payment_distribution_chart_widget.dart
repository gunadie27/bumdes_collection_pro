import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class PaymentDistributionChartWidget extends StatelessWidget {
  final Map<String, double> data;

  const PaymentDistributionChartWidget({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {},
                enabled: true,
              ),
              borderData: FlBorderData(show: false),
              sectionsSpace: 2,
              centerSpaceRadius: 50,
              sections: _buildPieChartSections(),
            ),
          ),
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: _buildLegend(),
        ),
      ],
    );
  }

  List<PieChartSectionData> _buildPieChartSections() {
    final colors = [
      AppTheme.lightTheme.colorScheme.primary,
      AppTheme.successLight,
      AppTheme.warningLight,
      AppTheme.errorLight,
    ];

    return data.entries.map((entry) {
      final index = data.keys.toList().indexOf(entry.key);
      final color = colors[index % colors.length];
      final total = data.values.reduce((a, b) => a + b);
      final percentage = (entry.value / total) * 100;

      return PieChartSectionData(
        color: color,
        value: entry.value,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 60,
        titleStyle: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: AppTheme.lightTheme.colorScheme.onPrimary,
        ),
        titlePositionPercentageOffset: 0.6,
      );
    }).toList();
  }

  Widget _buildLegend() {
    final colors = [
      AppTheme.lightTheme.colorScheme.primary,
      AppTheme.successLight,
      AppTheme.warningLight,
      AppTheme.errorLight,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: data.entries.map((entry) {
        final index = data.keys.toList().indexOf(entry.key);
        final color = colors[index % colors.length];

        return Padding(
          padding: EdgeInsets.only(bottom: 2.h),
          child: Row(
            children: [
              Container(
                width: 4.w,
                height: 4.w,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2.w),
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.key,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${entry.value.toInt()} transaksi',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.textTheme.bodySmall?.color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
