import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ExportSectionWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String icon;
  final List<String> exportFormats;
  final Function(String format) onExport;

  const ExportSectionWidget({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.exportFormats,
    required this.onExport,
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
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  ),
                  child: CustomIconWidget(
                    iconName: icon,
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 6.w,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        subtitle,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // Export Format Options
            Row(
              children: [
                Text(
                  "Format Ekspor:",
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Wrap(
                    spacing: 2.w,
                    children: exportFormats
                        .map((format) => _buildFormatChip(context, format))
                        .toList(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormatChip(BuildContext context, String format) {
    return GestureDetector(
      onTap: () => onExport(format),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: _getFormatColor(format).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          border: Border.all(
            color: _getFormatColor(format),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: _getFormatIcon(format),
              color: _getFormatColor(format),
              size: 4.w,
            ),
            SizedBox(width: 1.w),
            Text(
              format,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: _getFormatColor(format),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getFormatColor(String format) {
    switch (format.toLowerCase()) {
      case 'pdf':
        return const Color(0xFFD32F2F);
      case 'excel':
        return const Color(0xFF1976D2);
      case 'csv':
        return const Color(0xFF388E3C);
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
  }

  String _getFormatIcon(String format) {
    switch (format.toLowerCase()) {
      case 'pdf':
        return 'picture_as_pdf';
      case 'excel':
        return 'table_chart';
      case 'csv':
        return 'text_snippet';
      default:
        return 'file_download';
    }
  }
}
