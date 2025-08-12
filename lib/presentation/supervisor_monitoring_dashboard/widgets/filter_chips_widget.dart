import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterChipsWidget extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterChanged;

  const FilterChipsWidget({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> filters = [
      {'label': 'Semua', 'value': 'all', 'icon': 'filter_list'},
      {'label': 'Performa', 'value': 'performance', 'icon': 'trending_up'},
      {'label': 'Lokasi', 'value': 'location', 'icon': 'location_on'},
      {'label': 'Status', 'value': 'status', 'icon': 'circle'},
    ];

    return Container(
      height: 6.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: filters.length,
        separatorBuilder: (context, index) => SizedBox(width: 3.w),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = selectedFilter == filter['value'];

          return FilterChip(
            selected: isSelected,
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: filter['icon'] as String,
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.onPrimary
                      : AppTheme.lightTheme.colorScheme.primary,
                  size: 4.w,
                ),
                SizedBox(width: 2.w),
                Text(
                  filter['label'] as String,
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.onPrimary
                        : AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ],
            ),
            selectedColor: AppTheme.lightTheme.colorScheme.primary,
            backgroundColor: AppTheme.lightTheme.colorScheme.surface,
            side: BorderSide(
              color: isSelected
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.dividerColor,
              width: 1,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
            ),
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            onSelected: (selected) {
              if (selected) {
                onFilterChanged(filter['value'] as String);
              }
            },
          );
        },
      ),
    );
  }
}
