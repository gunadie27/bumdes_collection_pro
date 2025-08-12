import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BulkActionsSheetWidget extends StatelessWidget {
  final VoidCallback? onSendNotifications;
  final VoidCallback? onGenerateReports;
  final VoidCallback? onScheduleMeetings;

  const BulkActionsSheetWidget({
    super.key,
    this.onSendNotifications,
    this.onGenerateReports,
    this.onScheduleMeetings,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppTheme.radiusLarge)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 3.h),

          // Title
          Text(
            'Aksi Massal',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Pilih aksi yang ingin dilakukan untuk semua kolektor',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.textTheme.bodySmall?.color,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),

          // Action buttons
          _buildActionTile(
            context,
            icon: 'notifications',
            title: 'Kirim Notifikasi',
            subtitle: 'Kirim pesan atau pengingat ke semua kolektor',
            color: AppTheme.lightTheme.colorScheme.primary,
            onTap: () {
              Navigator.pop(context);
              onSendNotifications?.call();
            },
          ),

          SizedBox(height: 2.h),

          _buildActionTile(
            context,
            icon: 'assessment',
            title: 'Generate Laporan',
            subtitle: 'Buat laporan kinerja harian atau mingguan',
            color: AppTheme.warningLight,
            onTap: () {
              Navigator.pop(context);
              onGenerateReports?.call();
            },
          ),

          SizedBox(height: 2.h),

          _buildActionTile(
            context,
            icon: 'event',
            title: 'Jadwalkan Rapat',
            subtitle: 'Atur pertemuan dengan tim kolektor',
            color: AppTheme.successLight,
            onTap: () {
              Navigator.pop(context);
              onScheduleMeetings?.call();
            },
          ),

          SizedBox(height: 4.h),

          // Cancel button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 3.h),
                side: BorderSide(
                  color: AppTheme.lightTheme.dividerColor,
                  width: 1,
                ),
              ),
              child: Text(
                'Batal',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.lightTheme.textTheme.bodySmall?.color,
                ),
              ),
            ),
          ),

          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildActionTile(
    BuildContext context, {
    required String icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          border: Border.all(
            color: color.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              ),
              child: CustomIconWidget(
                iconName: icon,
                color: Colors.white,
                size: 6.w,
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    subtitle,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'arrow_forward_ios',
              color: color,
              size: 4.w,
            ),
          ],
        ),
      ),
    );
  }
}
