import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ExportQueueWidget extends StatelessWidget {
  final List<Map<String, dynamic>> exportQueue;
  final Function(String taskId) onCancelExport;
  final Function(String taskId) onRetryExport;

  const ExportQueueWidget({
    Key? key,
    required this.exportQueue,
    required this.onCancelExport,
    required this.onRetryExport,
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
                  iconName: 'queue',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 5.w,
                ),
                SizedBox(width: 2.w),
                Text(
                  "Antrian Ekspor",
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  ),
                  child: Text(
                    "${exportQueue.length}",
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            ...exportQueue
                .map((task) => _buildQueueItem(context, task))
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildQueueItem(BuildContext context, Map<String, dynamic> task) {
    final status = task['status'] as String;
    final progress = task['progress'] as double;
    final category = task['category'] as String;
    final format = task['format'] as String;

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        border: Border.all(
          color: _getStatusColor(status).withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: _getStatusColor(status).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                ),
                child: CustomIconWidget(
                  iconName: _getStatusIcon(status),
                  color: _getStatusColor(status),
                  size: 4.w,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getCategoryName(category),
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      "Format: $format",
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  if (status == 'processing') ...[
                    IconButton(
                      onPressed: () => onCancelExport(task['id']),
                      icon: CustomIconWidget(
                        iconName: 'cancel',
                        color: AppTheme.lightTheme.colorScheme.error,
                        size: 5.w,
                      ),
                    ),
                  ] else if (status == 'failed') ...[
                    IconButton(
                      onPressed: () => onRetryExport(task['id']),
                      icon: CustomIconWidget(
                        iconName: 'refresh',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 5.w,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Progress Bar
          if (status == 'processing') ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Progress:",
                      style: AppTheme.lightTheme.textTheme.bodySmall,
                    ),
                    Text(
                      "${progress.toStringAsFixed(0)}%",
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                LinearProgressIndicator(
                  value: progress / 100,
                  backgroundColor: AppTheme.lightTheme.dividerColor,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(_getStatusColor(status)),
                ),
                SizedBox(height: 1.h),
                Text(
                  _getEstimatedTime(task),
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ] else ...[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: _getStatusColor(status).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: _getStatusIcon(status),
                    color: _getStatusColor(status),
                    size: 3.w,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    _getStatusText(status),
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: _getStatusColor(status),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'processing':
        return AppTheme.warningLight;
      case 'completed':
        return AppTheme.successLight;
      case 'failed':
        return AppTheme.lightTheme.colorScheme.error;
      default:
        return AppTheme.lightTheme.colorScheme.onSurface;
    }
  }

  String _getStatusIcon(String status) {
    switch (status) {
      case 'processing':
        return 'hourglass_empty';
      case 'completed':
        return 'check_circle';
      case 'failed':
        return 'error';
      default:
        return 'help';
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'processing':
        return 'Memproses';
      case 'completed':
        return 'Selesai';
      case 'failed':
        return 'Gagal';
      default:
        return 'Tidak Diketahui';
    }
  }

  String _getCategoryName(String category) {
    switch (category) {
      case 'collection_reports':
        return 'Laporan Penagihan';
      case 'performance_analytics':
        return 'Analisis Performa';
      case 'member_data':
        return 'Data Member';
      case 'financial_summaries':
        return 'Ringkasan Keuangan';
      default:
        return category;
    }
  }

  String _getEstimatedTime(Map<String, dynamic> task) {
    final estimatedCompletion = task['estimatedCompletion'] as DateTime;
    final now = DateTime.now();
    final remaining = estimatedCompletion.difference(now);

    if (remaining.inMinutes > 0) {
      return "Estimasi: ${remaining.inMinutes} menit lagi";
    } else {
      return "Hampir selesai...";
    }
  }
}
