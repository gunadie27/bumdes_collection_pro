import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class GroupCardWidget extends StatelessWidget {
  final Map<String, dynamic> groupData;
  final VoidCallback? onTap;
  final VoidCallback? onVisitNow;
  final VoidCallback? onViewDetail;
  final VoidCallback? onMakeAppointment;

  const GroupCardWidget({
    Key? key,
    required this.groupData,
    this.onTap,
    this.onVisitNow,
    this.onViewDetail,
    this.onMakeAppointment,
  }) : super(key: key);

  Color _getPriorityColor() {
    final priority = groupData['priority'] as String? ?? 'medium';
    switch (priority.toLowerCase()) {
      case 'high':
        return AppTheme.lightTheme.colorScheme.error;
      case 'medium':
        return AppTheme.warningLight;
      case 'low':
        return AppTheme.successLight;
      default:
        return AppTheme.lightTheme.colorScheme.secondary;
    }
  }

  String _formatCurrency(double amount) {
    return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')},00';
  }

  @override
  Widget build(BuildContext context) {
    final village = groupData['village'] as String? ?? '';
    final groupLeader = groupData['groupLeader'] as String? ?? '';
    final memberCount = groupData['memberCount'] as int? ?? 0;
    final totalDebt = (groupData['totalDebt'] as num?)?.toDouble() ?? 0.0;
    final priority = groupData['priority'] as String? ?? 'medium';

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Card(
        elevation: AppTheme.elevationLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          child: Container(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            village,
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            'Ketua: $groupLeader',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 3.w,
                      height: 6.h,
                      decoration: BoxDecoration(
                        color: _getPriorityColor(),
                        borderRadius: BorderRadius.circular(2.w),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'people',
                                color: AppTheme.lightTheme.colorScheme.primary,
                                size: 16,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                '$memberCount Anggota',
                                style: AppTheme.lightTheme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            _formatCurrency(totalDebt),
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.error,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        switch (value) {
                          case 'visit':
                            onVisitNow?.call();
                            break;
                          case 'detail':
                            onViewDetail?.call();
                            break;
                          case 'appointment':
                            onMakeAppointment?.call();
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'visit',
                          child: Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'location_on',
                                color: AppTheme.lightTheme.colorScheme.primary,
                                size: 20,
                              ),
                              SizedBox(width: 3.w),
                              Text('Kunjungi Sekarang'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'detail',
                          child: Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'info',
                                color: AppTheme.lightTheme.colorScheme.primary,
                                size: 20,
                              ),
                              SizedBox(width: 3.w),
                              Text('Lihat Detail'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'appointment',
                          child: Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'schedule',
                                color: AppTheme.lightTheme.colorScheme.primary,
                                size: 20,
                              ),
                              SizedBox(width: 3.w),
                              Text('Buat Janji'),
                            ],
                          ),
                        ),
                      ],
                      child: Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.surface,
                          borderRadius:
                              BorderRadius.circular(AppTheme.radiusSmall),
                          border: Border.all(
                            color: AppTheme.lightTheme.colorScheme.outline,
                          ),
                        ),
                        child: CustomIconWidget(
                          iconName: 'more_vert',
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
