import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class AgreementTabsWidget extends StatelessWidget {
  final TabController tabController;
  final int activeCount;
  final int overdueCount;
  final int completedCount;

  const AgreementTabsWidget({
    super.key,
    required this.tabController,
    required this.activeCount,
    required this.overdueCount,
    required this.completedCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.lightTheme.colorScheme.surface,
      child: TabBar(
        controller: tabController,
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Aktif'),
                SizedBox(width: 2.w),
                _buildCountBadge(
                    activeCount, AppTheme.lightTheme.colorScheme.primary),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Jatuh Tempo'),
                SizedBox(width: 2.w),
                _buildCountBadge(overdueCount, AppTheme.errorLight),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Selesai'),
                SizedBox(width: 2.w),
                _buildCountBadge(completedCount, AppTheme.successLight),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountBadge(int count, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        count.toString(),
        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
