import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CollectorCardWidget extends StatelessWidget {
  final Map<String, dynamic> collector;
  final VoidCallback? onTap;
  final VoidCallback? onViewRoute;
  final VoidCallback? onSendMessage;
  final VoidCallback? onViewReport;

  const CollectorCardWidget({
    super.key,
    required this.collector,
    this.onTap,
    this.onViewRoute,
    this.onSendMessage,
    this.onViewReport,
  });

  @override
  Widget build(BuildContext context) {
    final String status = collector['status'] as String? ?? 'Offline';
    final int visitCount = collector['visitCount'] as int? ?? 0;
    final double amountCollected =
        collector['amountCollected'] as double? ?? 0.0;
    final String lastActivity =
        collector['lastActivity'] as String? ?? 'Tidak ada aktivitas';

    return Dismissible(
      key: Key(collector['id'].toString()),
      direction: DismissDirection.startToEnd,
      background: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
        child: Row(
          children: [
            SizedBox(width: 6.w),
            CustomIconWidget(
              iconName: 'route',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 6.w,
            ),
            SizedBox(width: 4.w),
            Text(
              'Lihat Rute',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
            const Spacer(),
            CustomIconWidget(
              iconName: 'message',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 6.w,
            ),
            SizedBox(width: 4.w),
            Text(
              'Kirim Pesan',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
            const Spacer(),
            CustomIconWidget(
              iconName: 'assessment',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 6.w,
            ),
            SizedBox(width: 4.w),
            Text(
              'Lihat Laporan',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
            SizedBox(width: 6.w),
          ],
        ),
      ),
      onDismissed: (direction) {
        _showQuickActions(context);
      },
      child: GestureDetector(
        onTap: onTap,
        onLongPress: () => _showContextMenu(context),
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          elevation: AppTheme.elevationLow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          ),
          child: Container(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                // Profile Photo
                Container(
                  width: 15.w,
                  height: 15.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _getStatusColor(status),
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: CustomImageWidget(
                      imageUrl: collector['profilePhoto'] as String? ??
                          'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png',
                      width: 15.w,
                      height: 15.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 4.w),

                // Collector Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              collector['name'] as String? ??
                                  'Nama Tidak Diketahui',
                              style: AppTheme.lightTheme.textTheme.titleMedium
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
                              color: _getStatusColor(status)
                                  .withValues(alpha: 0.1),
                              borderRadius:
                                  BorderRadius.circular(AppTheme.radiusSmall),
                            ),
                            child: Text(
                              status,
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: _getStatusColor(status),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.h),

                      // Collection Summary
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Kunjungan Hari Ini',
                                  style:
                                      AppTheme.lightTheme.textTheme.bodySmall,
                                ),
                                Text(
                                  '$visitCount kunjungan',
                                  style: AppTheme
                                      .lightTheme.textTheme.labelLarge
                                      ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Terkumpul',
                                  style:
                                      AppTheme.lightTheme.textTheme.bodySmall,
                                ),
                                Text(
                                  _formatCurrency(amountCollected),
                                  style:
                                      AppTheme.currencyTextStyle(isLight: true)
                                          .copyWith(
                                    color:
                                        AppTheme.lightTheme.colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.h),

                      // Last Activity
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'access_time',
                            color: AppTheme
                                    .lightTheme.textTheme.bodySmall?.color ??
                                Colors.grey,
                            size: 4.w,
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: Text(
                              'Terakhir aktif: $lastActivity',
                              style: AppTheme.lightTheme.textTheme.bodySmall,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'idle':
        return AppTheme.warningLight;
      case 'offline':
      default:
        return AppTheme.lightTheme.textTheme.bodySmall?.color ?? Colors.grey;
    }
  }

  String _formatCurrency(double amount) {
    return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  void _showQuickActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppTheme.radiusLarge)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Aksi Cepat',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'route',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              title: Text('Lihat Rute'),
              onTap: () {
                Navigator.pop(context);
                onViewRoute?.call();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'message',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              title: Text('Kirim Pesan'),
              onTap: () {
                Navigator.pop(context);
                onSendMessage?.call();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'assessment',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              title: Text('Lihat Laporan'),
              onTap: () {
                Navigator.pop(context);
                onViewReport?.call();
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppTheme.radiusLarge)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              collector['name'] as String? ?? 'Kolektor',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'phone',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              title: Text('Hubungi Kolektor'),
              onTap: () {
                Navigator.pop(context);
                // Handle call collector
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'history',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              title: Text('Lihat Riwayat Lengkap'),
              onTap: () {
                Navigator.pop(context);
                // Handle view full history
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'assignment',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              title: Text('Tugaskan Akun Baru'),
              onTap: () {
                Navigator.pop(context);
                // Handle assign new accounts
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
