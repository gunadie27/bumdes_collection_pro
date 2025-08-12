import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class PaymentAmountWidget extends StatefulWidget {
  final Function(String) onAmountChanged;
  final String? initialAmount;

  const PaymentAmountWidget({
    Key? key,
    required this.onAmountChanged,
    this.initialAmount,
  }) : super(key: key);

  @override
  State<PaymentAmountWidget> createState() => _PaymentAmountWidgetState();
}

class _PaymentAmountWidgetState extends State<PaymentAmountWidget> {
  final TextEditingController _amountController = TextEditingController();
  String _selectedCurrency = 'IDR';

  @override
  void initState() {
    super.initState();
    if (widget.initialAmount != null) {
      _amountController.text = widget.initialAmount!;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  String _formatCurrency(String value) {
    if (value.isEmpty) return '';

    // Remove all non-digit characters
    String digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.isEmpty) return '';

    // Convert to number and format with thousand separators
    int number = int.parse(digitsOnly);
    String formatted = number.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );

    return formatted;
  }

  void _onAmountChanged(String value) {
    String formatted = _formatCurrency(value);

    // Update controller with formatted value
    _amountController.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );

    // Return raw number to parent
    String rawValue = value.replaceAll(RegExp(r'[^\d]'), '');
    widget.onAmountChanged(rawValue);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'payments',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 3.w),
              Text(
                'Jumlah Pembayaran',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              // Currency Picker
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primaryContainer
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedCurrency,
                    isDense: true,
                    items: ['IDR'].map((String currency) {
                      return DropdownMenuItem<String>(
                        value: currency,
                        child: Text(
                          currency,
                          style: AppTheme.lightTheme.textTheme.titleSmall
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.lightTheme.colorScheme.primary,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedCurrency = newValue;
                        });
                      }
                    },
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              // Amount Input
              Expanded(
                child: TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onChanged: _onAmountChanged,
                  style: AppTheme.currencyTextStyle(isLight: true).copyWith(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    hintText: '0',
                    hintStyle:
                        AppTheme.currencyTextStyle(isLight: true).copyWith(
                      fontSize: 18.sp,
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                          .withValues(alpha: 0.6),
                    ),
                    prefixText: 'Rp ',
                    prefixStyle:
                        AppTheme.currencyTextStyle(isLight: true).copyWith(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppTheme.radiusMedium),
                      borderSide: BorderSide(
                        color: AppTheme.lightTheme.colorScheme.outline,
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppTheme.radiusMedium),
                      borderSide: BorderSide(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        width: 2.0,
                      ),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            'Masukkan jumlah pembayaran yang diterima',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
