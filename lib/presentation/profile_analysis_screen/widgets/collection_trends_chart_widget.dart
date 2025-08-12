import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class CollectionTrendsChartWidget extends StatelessWidget {
  final List<Map<String, dynamic>> weeklyData;

  const CollectionTrendsChartWidget({
    super.key,
    required this.weeklyData,
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
                "Tren Kunjungan Mingguan",
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Icon(
                Icons.timeline,
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 5.w,
              ),
            ],
          ),
          SizedBox(height: 3.h),
          SizedBox(
            height: 25.h,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 2,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: AppTheme.lightTheme.dividerColor,
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() < weeklyData.length) {
                          return Text(
                            weeklyData[value.toInt()]["week"] as String,
                            style: AppTheme.lightTheme.textTheme.bodySmall,
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 8.w,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: AppTheme.lightTheme.textTheme.bodySmall,
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    bottom: BorderSide(
                      color: AppTheme.lightTheme.dividerColor,
                      width: 1,
                    ),
                    left: BorderSide(
                      color: AppTheme.lightTheme.dividerColor,
                      width: 1,
                    ),
                  ),
                ),
                minX: 0,
                maxX: (weeklyData.length - 1).toDouble(),
                minY: 0,
                maxY: _getMaxY(),
                lineBarsData: [
                  // Collections line
                  LineChartBarData(
                    spots: _getCollectionSpots(),
                    isCurved: true,
                    color: AppTheme.lightTheme.colorScheme.primary,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) =>
                          FlDotCirclePainter(
                        radius: 4,
                        color: AppTheme.lightTheme.colorScheme.primary,
                        strokeWidth: 2,
                        strokeColor: AppTheme.lightTheme.cardColor,
                      ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.1),
                    ),
                  ),
                  // Success line
                  LineChartBarData(
                    spots: _getSuccessSpots(),
                    isCurved: true,
                    color: AppTheme.successLight,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) =>
                          FlDotCirclePainter(
                        radius: 4,
                        color: AppTheme.successLight,
                        strokeWidth: 2,
                        strokeColor: AppTheme.lightTheme.cardColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 2.h),
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem(
                "Total Kunjungan",
                AppTheme.lightTheme.colorScheme.primary,
              ),
              SizedBox(width: 6.w),
              _buildLegendItem(
                "Berhasil",
                AppTheme.successLight,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
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
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall,
        ),
      ],
    );
  }

  List<FlSpot> _getCollectionSpots() {
    return weeklyData.asMap().entries.map((entry) {
      return FlSpot(
        entry.key.toDouble(),
        (entry.value["collections"] as int).toDouble(),
      );
    }).toList();
  }

  List<FlSpot> _getSuccessSpots() {
    return weeklyData.asMap().entries.map((entry) {
      return FlSpot(
        entry.key.toDouble(),
        (entry.value["success"] as int).toDouble(),
      );
    }).toList();
  }

  double _getMaxY() {
    int maxCollections = weeklyData
        .map((data) => data["collections"] as int)
        .reduce((a, b) => a > b ? a : b);
    return (maxCollections + 2).toDouble();
  }
}
