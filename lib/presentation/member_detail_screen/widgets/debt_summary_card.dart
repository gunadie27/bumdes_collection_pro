import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class DebtSummaryCard extends StatelessWidget {
  final Map<String, dynamic> debtData;

  const DebtSummaryCard({
    super.key,
    required this.debtData,
  });

  @override
  Widget build(BuildContext context) {
    final outstandingAmount = debtData["outstandingAmount"] as double? ?? 0.0;
    final originalAmount = debtData["originalAmount"] as double? ?? 0.0;
    final loanDate = debtData["loanDate"] as DateTime?;
    final overdueDays = debtData["overdueDays"] as int? ?? 0;
    final progress = originalAmount > 0
        ? (originalAmount - outstandingAmount) / originalAmount
        : 0.0;

    return Card(
      elevation: AppTheme.elevationLow,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.lightTheme.colorScheme.errorContainer
                  .withValues(alpha: 0.1),
              AppTheme.lightTheme.colorScheme.surface,
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'account_balance_wallet',
                    color: AppTheme.lightTheme.colorScheme.error,
                    size: 6.w,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    "Ringkasan Hutang",
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),

              // Outstanding Amount
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.errorContainer
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.error
                        .withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Sisa Hutang",
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.error,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      _formatCurrency(outstandingAmount),
                      style:
                          AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.error,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 2.h),

              // Loan Information
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Tanggal Pinjaman",
                          style: AppTheme.lightTheme.textTheme.bodySmall,
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          loanDate != null ? _formatDate(loanDate) : "N/A",
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hari Terlambat",
                          style: AppTheme.lightTheme.textTheme.bodySmall,
                        ),
                        SizedBox(height: 0.5.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: _getOverdueColor(overdueDays)
                                .withValues(alpha: 0.1),
                            borderRadius:
                                BorderRadius.circular(AppTheme.radiusSmall),
                          ),
                          child: Text(
                            "$overdueDays hari",
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: _getOverdueColor(overdueDays),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 2.h),

              // Progress Indicator
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Progress Pembayaran",
                        style: AppTheme.lightTheme.textTheme.bodySmall,
                      ),
                      Text(
                        "${(progress * 100).toStringAsFixed(1)}%",
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: AppTheme.lightTheme.dividerColor,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        progress > 0.7
                            ? AppTheme.lightTheme.colorScheme.tertiary
                            : progress > 0.3
                                ? AppTheme.warningLight
                                : AppTheme.lightTheme.colorScheme.error,
                      ),
                      minHeight: 1.h,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Terbayar: ${_formatCurrency(originalAmount - outstandingAmount)}",
                        style: AppTheme.lightTheme.textTheme.bodySmall,
                      ),
                      Text(
                        "Total: ${_formatCurrency(originalAmount)}",
                        style: AppTheme.lightTheme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatCurrency(double amount) {
    return "Rp ${amount.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        )},00";
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  Color _getOverdueColor(int days) {
    if (days <= 7) return AppTheme.warningLight;
    if (days <= 30) return AppTheme.lightTheme.colorScheme.error;
    return AppTheme.lightTheme.colorScheme.error;
  }
}
