import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AdvancedFilterWidget extends StatefulWidget {
  final Map<String, dynamic> activeFilters;
  final Function(Map<String, dynamic>) onFiltersChanged;

  const AdvancedFilterWidget({
    Key? key,
    required this.activeFilters,
    required this.onFiltersChanged,
  }) : super(key: key);

  @override
  State<AdvancedFilterWidget> createState() => _AdvancedFilterWidgetState();
}

class _AdvancedFilterWidgetState extends State<AdvancedFilterWidget> {
  bool _isExpanded = false;

  final List<String> _collectors = [
    'Ahmad Fauzi',
    'Siti Nurhaliza',
    'Budi Santoso',
    'Dewi Sartika'
  ];
  final List<String> _villages = [
    'Desa Maju',
    'Desa Sejahtera',
    'Desa Berkah',
    'Desa Makmur'
  ];
  final List<String> _paymentStatuses = [
    'Lunas',
    'Sebagian',
    'Belum Bayar',
    'Tertunggak'
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppTheme.elevationLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      child: Column(
        children: [
          _buildHeader(),
          if (_isExpanded) _buildFilterContent(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return InkWell(
      onTap: () => setState(() => _isExpanded = !_isExpanded),
      borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: 'filter_list',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 5.w,
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Text(
                "Filter Lanjutan",
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (widget.activeFilters.isNotEmpty) ...[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                ),
                child: Text(
                  widget.activeFilters.length.toString(),
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(width: 2.w),
            ],
            CustomIconWidget(
              iconName:
                  _isExpanded ? 'keyboard_arrow_up' : 'keyboard_arrow_down',
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.7),
              size: 5.w,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterContent() {
    return Padding(
      padding: EdgeInsets.all(4.w).copyWith(top: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(color: AppTheme.lightTheme.dividerColor),
          SizedBox(height: 2.h),

          // Collector Filter
          _buildMultiSelectFilter(
            "Collector",
            'collectors',
            _collectors,
            'person',
          ),

          SizedBox(height: 2.h),

          // Village Filter
          _buildMultiSelectFilter(
            "Desa",
            'villages',
            _villages,
            'location_on',
          ),

          SizedBox(height: 2.h),

          // Payment Status Filter
          _buildMultiSelectFilter(
            "Status Pembayaran",
            'paymentStatuses',
            _paymentStatuses,
            'payment',
          ),

          SizedBox(height: 2.h),

          // Amount Range Filter
          _buildAmountRangeFilter(),

          SizedBox(height: 3.h),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _clearAllFilters,
                  child: Text("Hapus Semua"),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: _applyFilters,
                  child: Text("Terapkan"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMultiSelectFilter(
    String title,
    String key,
    List<String> options,
    String icon,
  ) {
    final selectedOptions = widget.activeFilters[key] as List<String>? ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: icon,
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 4.w,
            ),
            SizedBox(width: 2.w),
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: options.map((option) {
            final isSelected = selectedOptions.contains(option);
            return GestureDetector(
              onTap: () => _toggleOption(key, option),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.1)
                      : AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.dividerColor,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isSelected) ...[
                      CustomIconWidget(
                        iconName: 'check',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 3.w,
                      ),
                      SizedBox(width: 1.w),
                    ],
                    Text(
                      option,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.onSurface,
                        fontWeight:
                            isSelected ? FontWeight.w500 : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAmountRangeFilter() {
    final minAmount = widget.activeFilters['minAmount'] as double? ?? 0;
    final maxAmount = widget.activeFilters['maxAmount'] as double? ?? 10000000;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: 'attach_money',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 4.w,
            ),
            SizedBox(width: 2.w),
            Text(
              "Rentang Jumlah",
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: minAmount > 0 ? minAmount.toStringAsFixed(0) : '',
                decoration: InputDecoration(
                  labelText: "Minimum",
                  prefixText: "Rp ",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  ),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  final amount = double.tryParse(value) ?? 0;
                  _updateAmountFilter('minAmount', amount);
                },
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: TextFormField(
                initialValue:
                    maxAmount < 10000000 ? maxAmount.toStringAsFixed(0) : '',
                decoration: InputDecoration(
                  labelText: "Maksimum",
                  prefixText: "Rp ",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  ),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  final amount = double.tryParse(value) ?? 10000000;
                  _updateAmountFilter('maxAmount', amount);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _toggleOption(String key, String option) {
    final currentOptions = widget.activeFilters[key] as List<String>? ?? [];
    final newOptions = List<String>.from(currentOptions);

    if (newOptions.contains(option)) {
      newOptions.remove(option);
    } else {
      newOptions.add(option);
    }

    final newFilters = Map<String, dynamic>.from(widget.activeFilters);
    if (newOptions.isEmpty) {
      newFilters.remove(key);
    } else {
      newFilters[key] = newOptions;
    }

    widget.onFiltersChanged(newFilters);
  }

  void _updateAmountFilter(String key, double value) {
    final newFilters = Map<String, dynamic>.from(widget.activeFilters);
    if (value <= 0 && key == 'minAmount') {
      newFilters.remove(key);
    } else if (value >= 10000000 && key == 'maxAmount') {
      newFilters.remove(key);
    } else {
      newFilters[key] = value;
    }

    widget.onFiltersChanged(newFilters);
  }

  void _clearAllFilters() {
    widget.onFiltersChanged({});
  }

  void _applyFilters() {
    setState(() => _isExpanded = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text("Filter diterapkan: ${widget.activeFilters.length} kriteria"),
        backgroundColor: AppTheme.successLight,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        ),
      ),
    );
  }
}
