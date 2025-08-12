import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SortBottomSheetWidget extends StatefulWidget {
  final String? currentSortOption;
  final ValueChanged<String>? onSortChanged;

  const SortBottomSheetWidget({
    Key? key,
    this.currentSortOption,
    this.onSortChanged,
  }) : super(key: key);

  @override
  State<SortBottomSheetWidget> createState() => _SortBottomSheetWidgetState();
}

class _SortBottomSheetWidgetState extends State<SortBottomSheetWidget> {
  String? _selectedSort;

  final List<Map<String, dynamic>> _sortOptions = [
    {
      'value': 'amount_desc',
      'label': 'Jumlah Tunggakan (Tertinggi)',
      'icon': 'trending_up',
    },
    {
      'value': 'amount_asc',
      'label': 'Jumlah Tunggakan (Terendah)',
      'icon': 'trending_down',
    },
    {
      'value': 'date_desc',
      'label': 'Tanggal Terbaru',
      'icon': 'schedule',
    },
    {
      'value': 'date_asc',
      'label': 'Tanggal Terlama',
      'icon': 'history',
    },
    {
      'value': 'priority_high',
      'label': 'Prioritas Tinggi',
      'icon': 'priority_high',
    },
    {
      'value': 'distance_near',
      'label': 'Jarak Terdekat',
      'icon': 'location_on',
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedSort = widget.currentSortOption;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppTheme.radiusLarge),
          topRight: Radius.circular(AppTheme.radiusLarge),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.only(top: 2.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline,
              borderRadius: BorderRadius.circular(1.w),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Urutkan Berdasarkan',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 3.h),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _sortOptions.length,
                  separatorBuilder: (context, index) => SizedBox(height: 1.h),
                  itemBuilder: (context, index) {
                    final option = _sortOptions[index];
                    final isSelected = _selectedSort == option['value'];

                    return ListTile(
                      onTap: () {
                        setState(() {
                          _selectedSort = option['value'];
                        });
                        widget.onSortChanged?.call(option['value']);
                        Navigator.pop(context);
                      },
                      leading: CustomIconWidget(
                        iconName: option['icon'],
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 24,
                      ),
                      title: Text(
                        option['label'],
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: isSelected
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme.lightTheme.colorScheme.onSurface,
                          fontWeight:
                              isSelected ? FontWeight.w500 : FontWeight.w400,
                        ),
                      ),
                      trailing: isSelected
                          ? CustomIconWidget(
                              iconName: 'check',
                              color: AppTheme.lightTheme.colorScheme.primary,
                              size: 20,
                            )
                          : null,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusSmall),
                      ),
                      tileColor: isSelected
                          ? AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.1)
                          : null,
                    );
                  },
                ),
                SizedBox(height: 2.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
