import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterSectionWidget extends StatelessWidget {
  final String selectedCollector;
  final String selectedVillage;
  final String selectedPaymentStatus;
  final String selectedAmountRange;
  final Function(String) onCollectorChanged;
  final Function(String) onVillageChanged;
  final Function(String) onPaymentStatusChanged;
  final Function(String) onAmountRangeChanged;

  const FilterSectionWidget({
    super.key,
    required this.selectedCollector,
    required this.selectedVillage,
    required this.selectedPaymentStatus,
    required this.selectedAmountRange,
    required this.onCollectorChanged,
    required this.onVillageChanged,
    required this.onPaymentStatusChanged,
    required this.onAmountRangeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'filter_list',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 5.w,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Filter Lanjutan',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            Row(
              children: [
                Expanded(
                  child: _buildDropdown(
                    'Kolektor',
                    selectedCollector,
                    [
                      'all',
                      'Ahmad Rizki',
                      'Siti Nurhaliza',
                      'Maya Indira',
                      'Dewi Kartika'
                    ],
                    onCollectorChanged,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: _buildDropdown(
                    'Desa',
                    selectedVillage,
                    [
                      'all',
                      'Desa Sukamaju',
                      'Desa Makmur',
                      'Desa Berkah',
                      'Desa Maju Bersama'
                    ],
                    onVillageChanged,
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            Row(
              children: [
                Expanded(
                  child: _buildDropdown(
                    'Status Pembayaran',
                    selectedPaymentStatus,
                    ['all', 'Lunas', 'Tertunda', 'Gagal'],
                    onPaymentStatusChanged,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: _buildDropdown(
                    'Rentang Jumlah',
                    selectedAmountRange,
                    ['all', '< 500rb', '500rb - 1jt', '1jt - 2jt', '> 2jt'],
                    onAmountRangeChanged,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    String value,
    List<String> items,
    Function(String) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              borderSide: BorderSide(
                color: AppTheme.lightTheme.colorScheme.outline,
              ),
            ),
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item == 'all' ? 'Semua' : item,
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              onChanged(newValue);
            }
          },
        ),
      ],
    );
  }
}
