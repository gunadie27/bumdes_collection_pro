import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class AchievementSectionWidget extends StatelessWidget {
  final List<Map<String, dynamic>> achievements;

  const AchievementSectionWidget({
    super.key,
    required this.achievements,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Text(
              "Pencapaian",
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 1.h),
          SizedBox(
            height: 18.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              itemCount: achievements.length,
              itemBuilder: (context, index) {
                final achievement = achievements[index];
                return _buildAchievementCard(achievement);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementCard(Map<String, dynamic> achievement) {
    final isEarned = achievement["isEarned"] as bool;
    final progress = achievement["progress"] as double? ?? 0.0;

    return Container(
      width: 35.w,
      margin: EdgeInsets.only(right: 3.w),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(
          color: isEarned
              ? AppTheme.accentLight.withValues(alpha: 0.3)
              : AppTheme.lightTheme.dividerColor,
          width: isEarned ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Achievement Icon
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: isEarned
                  ? AppTheme.accentLight.withValues(alpha: 0.1)
                  : AppTheme.lightTheme.dividerColor.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getAchievementIcon(achievement["icon"] as String? ?? "trophy"),
              color: isEarned
                  ? AppTheme.accentLight
                  : AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.5),
              size: 6.w,
            ),
          ),

          SizedBox(height: 1.h),

          // Achievement Title
          Text(
            achievement["title"] as String? ?? "Unknown Achievement",
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: isEarned
                  ? AppTheme.lightTheme.colorScheme.onSurface
                  : AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: 0.5.h),

          // Achievement Description or Progress
          if (isEarned) ...[
            Text(
              "Diraih ${_formatDate(achievement["earnedDate"] as DateTime)}",
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.accentLight,
                fontSize: 10.sp,
              ),
              textAlign: TextAlign.center,
            ),
          ] else ...[
            // Progress indicator for unearned achievements
            Column(
              children: [
                LinearProgressIndicator(
                  value: progress / 100,
                  backgroundColor: AppTheme.lightTheme.dividerColor,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.lightTheme.colorScheme.primary,
                  ),
                  minHeight: 0.5.h,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  "${progress.toStringAsFixed(0)}%",
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    fontSize: 10.sp,
                    color: AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  IconData _getAchievementIcon(String iconName) {
    switch (iconName) {
      case 'trophy':
        return Icons.emoji_events;
      case 'star':
        return Icons.star;
      case 'medal':
        return Icons.military_tech;
      case 'crown':
        return Icons.workspace_premium;
      default:
        return Icons.emoji_events;
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return "${date.day} ${months[date.month - 1]} ${date.year}";
  }
}
