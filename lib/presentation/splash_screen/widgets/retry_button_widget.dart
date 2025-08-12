import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RetryButtonWidget extends StatelessWidget {
  final VoidCallback onRetry;

  const RetryButtonWidget({
    super.key,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomIconWidget(
          iconName: 'wifi_off',
          color: AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.7),
          size: 8.w,
        ),
        SizedBox(height: 2.h),
        Text(
          'Koneksi bermasalah',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color:
                AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.9),
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'Periksa koneksi internet Anda',
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color:
                AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.7),
          ),
        ),
        SizedBox(height: 3.h),
        ElevatedButton(
          onPressed: onRetry,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.lightTheme.colorScheme.surface,
            foregroundColor: AppTheme.primaryLight,
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          child: Text(
            'Coba Lagi',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
