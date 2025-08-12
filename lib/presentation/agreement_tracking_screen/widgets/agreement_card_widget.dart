import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class AgreementCardWidget extends StatelessWidget {
  final Map<String, dynamic> agreement;
  final VoidCallback onTap;
  final VoidCallback onContact;
  final VoidCallback onReschedule;
  final VoidCallback onMarkCompleted;

  const AgreementCardWidget({
    super.key,
    required this.agreement,
    required this.onTap,
    required this.onContact,
    required this.onReschedule,
    required this.onMarkCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final isOverdue = _isOverdue(agreement['dueDate']);
    final daysUntilDue = _getDaysUntilDue(agreement['dueDate']);

    return Dismissible(
      key: Key(agreement['id'].toString()),
      background: _buildSwipeBackground(
        color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.2),
        icon: Icons.phone,
        label: 'Hubungi',
        alignment: Alignment.centerLeft,
      ),
      secondaryBackground: _buildSwipeBackground(
        color: AppTheme.successLight.withValues(alpha: 0.2),
        icon: Icons.check_circle,
        label: 'Lunas',
        alignment: Alignment.centerRight,
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          onContact();
          return false;
        } else if (direction == DismissDirection.endToStart) {
          onMarkCompleted();
          return true;
        }
        return false;
      },
      child: Card(
        margin: EdgeInsets.only(bottom: 3.h),
        elevation: AppTheme.elevationLow,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    CircleAvatar(
                      radius: 6.w,
                      backgroundImage: NetworkImage(agreement['memberPhoto']),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            agreement['memberName'],
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            agreement['village'],
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.textTheme.bodySmall?.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildPriorityChip(agreement['priority']),
                  ],
                ),

                SizedBox(height: 3.h),

                // Amount Information
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoColumn(
                        'Jumlah Janji',
                        'Rp ${_formatCurrency(agreement['promisedAmount'])}',
                        AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                    Expanded(
                      child: _buildInfoColumn(
                        'Total Hutang',
                        'Rp ${_formatCurrency(agreement['originalDebt'])}',
                        AppTheme.lightTheme.textTheme.bodyMedium?.color ??
                            Colors.grey,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 2.h),

                // Due Date and Countdown
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: isOverdue
                        ? AppTheme.errorLight.withValues(alpha: 0.1)
                        : AppTheme.lightTheme.colorScheme.primaryContainer
                            .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                    border: Border.all(
                      color: isOverdue
                          ? AppTheme.errorLight.withValues(alpha: 0.3)
                          : AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isOverdue ? Icons.warning : Icons.schedule,
                        color: isOverdue
                            ? AppTheme.errorLight
                            : AppTheme.lightTheme.colorScheme.primary,
                        size: 5.w,
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Jatuh Tempo: ${_formatDate(agreement['dueDate'])}',
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              isOverdue
                                  ? 'Terlambat ${-daysUntilDue} hari'
                                  : daysUntilDue == 0
                                      ? 'Jatuh tempo hari ini'
                                      : '$daysUntilDue hari lagi',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: isOverdue
                                    ? AppTheme.errorLight
                                    : AppTheme.lightTheme.colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (agreement['status'] != 'Selesai')
                        _buildCountdownTimer(daysUntilDue, isOverdue),
                    ],
                  ),
                ),

                if (agreement['notes'].isNotEmpty) ...[
                  SizedBox(height: 2.h),
                  Text(
                    agreement['notes'],
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: AppTheme.lightTheme.textTheme.bodySmall?.color,
                    ),
                  ),
                ],

                // Quick Actions
                if (agreement['status'] != 'Selesai') ...[
                  SizedBox(height: 3.h),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onContact,
                          icon: const Icon(Icons.phone, size: 16),
                          label: const Text('Hubungi'),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onReschedule,
                          icon: const Icon(Icons.schedule, size: 16),
                          label: const Text('Reschedule'),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeBackground({
    required Color color,
    required IconData icon,
    required String label,
    required Alignment alignment,
  }) {
    return Container(
      alignment: alignment,
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 8.w),
          SizedBox(height: 1.h),
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.textTheme.bodySmall?.color,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildPriorityChip(String priority) {
    Color color;
    String label;

    switch (priority) {
      case 'urgent':
        color = AppTheme.errorLight;
        label = 'Mendesak';
        break;
      case 'high':
        color = AppTheme.warningLight;
        label = 'Tinggi';
        break;
      case 'medium':
        color = AppTheme.lightTheme.colorScheme.primary;
        label = 'Sedang';
        break;
      case 'low':
        color = AppTheme.successLight;
        label = 'Rendah';
        break;
      case 'completed':
        color = AppTheme.successLight;
        label = 'Selesai';
        break;
      default:
        color = AppTheme.lightTheme.colorScheme.outline;
        label = 'Normal';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildCountdownTimer(int days, bool isOverdue) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: isOverdue
            ? AppTheme.errorLight
            : days <= 1
                ? AppTheme.warningLight
                : AppTheme.lightTheme.colorScheme.primary,
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
      ),
      child: Text(
        isOverdue ? '${-days}' : days.toString(),
        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _formatCurrency(double amount) {
    return amount.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    return '${date.day}/${date.month}/${date.year}';
  }

  bool _isOverdue(String dueDateString) {
    final dueDate = DateTime.parse(dueDateString);
    final now = DateTime.now();
    return now.isAfter(dueDate);
  }

  int _getDaysUntilDue(String dueDateString) {
    final dueDate = DateTime.parse(dueDateString);
    final now = DateTime.now();
    return dueDate.difference(now).inDays;
  }
}
