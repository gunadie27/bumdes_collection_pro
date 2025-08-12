import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class CollectionTrendsChartWidget extends StatelessWidget {
  final List<FlSpot> data;

  const CollectionTrendsChartWidget({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          drawHorizontalLine: true,
          horizontalInterval: 500000,
          verticalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
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
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (double value, TitleMeta meta) {
                const style = TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                );
                Widget text;
                switch (value.toInt()) {
                  case 1:
                    text = const Text('Sen', style: style);
                    break;
                  case 2:
                    text = const Text('Sel', style: style);
                    break;
                  case 3:
                    text = const Text('Rab', style: style);
                    break;
                  case 4:
                    text = const Text('Kam', style: style);
                    break;
                  case 5:
                    text = const Text('Jum', style: style);
                    break;
                  case 6:
                    text = const Text('Sab', style: style);
                    break;
                  case 7:
                    text = const Text('Min', style: style);
                    break;
                  default:
                    text = const Text('', style: style);
                    break;
                }
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: text,
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 500000,
              getTitlesWidget: (double value, TitleMeta meta) {
                final style = AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  fontSize: 10,
                );
                String text;
                if (value >= 1000000) {
                  text = '${(value / 1000000).toStringAsFixed(0)}M';
                } else if (value >= 1000) {
                  text = '${(value / 1000).toStringAsFixed(0)}K';
                } else {
                  text = value.toStringAsFixed(0);
                }
                return Text(text, style: style, textAlign: TextAlign.left);
              },
              reservedSize: 42,
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
        minX: 1,
        maxX: 7,
        minY: 0,
        maxY: 3000000,
        lineBarsData: [
          LineChartBarData(
            spots: data,
            isCurved: true,
            gradient: LinearGradient(
              colors: [
                AppTheme.lightTheme.colorScheme.primary,
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
              ],
            ),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: AppTheme.lightTheme.colorScheme.primary,
                  strokeWidth: 2,
                  strokeColor: AppTheme.lightTheme.colorScheme.surface,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.3),
                  AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              return touchedBarSpots.map((barSpot) {
                final flSpot = barSpot;
                return LineTooltipItem(
                  'Rp ${_formatCurrency(flSpot.y)}',
                  AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ) ??
                      const TextStyle(),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  String _formatCurrency(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}K';
    } else {
      return amount.toStringAsFixed(0);
    }
  }
}
