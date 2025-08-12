import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class LoadingIndicatorWidget extends StatelessWidget {
  const LoadingIndicatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 8.w,
          height: 8.w,
          child: CircularProgressIndicator(
            strokeWidth: 3.0,
            valueColor: AlwaysStoppedAnimation<Color>(
              AppTheme.lightTheme.colorScheme.surface,
            ),
            backgroundColor:
                AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.3),
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          'Memuat aplikasi...',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color:
                AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.9),
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}
