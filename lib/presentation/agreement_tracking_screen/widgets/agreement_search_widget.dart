import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class AgreementSearchWidget extends StatelessWidget {
  final String searchQuery;
  final Function(String) onSearchChanged;

  const AgreementSearchWidget({
    super.key,
    required this.searchQuery,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      color: AppTheme.lightTheme.colorScheme.surface,
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Cari berdasarkan nama member atau desa...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => onSearchChanged(''),
                )
              : null,
          contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            borderSide: BorderSide(
              color: AppTheme.lightTheme.colorScheme.outline,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            borderSide: BorderSide(
              color: AppTheme.lightTheme.colorScheme.primary,
              width: 2,
            ),
          ),
        ),
        onChanged: onSearchChanged,
      ),
    );
  }
}
