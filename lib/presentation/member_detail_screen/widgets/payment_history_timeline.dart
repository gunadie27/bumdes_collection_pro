import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class PaymentHistoryTimeline extends StatelessWidget {
  final List<Map<String, dynamic>> paymentHistory;
  final Function(String) onViewProof;
  final Function(Map<String, dynamic>) onEditNote;

  const PaymentHistoryTimeline({
    super.key,
    required this.paymentHistory,
    required this.onViewProof,
    required this.onEditNote,
  });

  @override
  Widget build(BuildContext context) {
    if (paymentHistory.isEmpty) {
      return Card(
        elevation: AppTheme.elevationLow,
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            children: [
              CustomIconWidget(
                iconName: 'history',
                color: AppTheme.lightTheme.colorScheme.outline,
                size: 12.w,
              ),
              SizedBox(height: 2.h),
              Text(
                "Belum Ada Riwayat Pembayaran",
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.outline,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                "Riwayat pembayaran akan muncul setelah ada transaksi",
                style: AppTheme.lightTheme.textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      elevation: AppTheme.elevationLow,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
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
                CustomIconWidget(
                  iconName: 'history',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 6.w,
                ),
                SizedBox(width: 3.w),
                Text(
                  "Riwayat Pembayaran",
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: paymentHistory.length,
              separatorBuilder: (context, index) => SizedBox(height: 2.h),
              itemBuilder: (context, index) {
                final payment = paymentHistory[index];
                return _buildPaymentItem(context, payment, index);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentItem(
      BuildContext context, Map<String, dynamic> payment, int index) {
    final date = payment["date"] as DateTime?;
    final amount = payment["amount"] as double? ?? 0.0;
    final note = payment["note"] as String? ?? "";
    final proofImage = payment["proofImage"] as String?;
    final status = payment["status"] as String? ?? "completed";

    return Dismissible(
      key: Key("payment_$index"),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: 'visibility',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 5.w,
            ),
            SizedBox(width: 2.w),
            Text(
              "Lihat Bukti",
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 4.w),
            CustomIconWidget(
              iconName: 'edit',
              color: AppTheme.lightTheme.colorScheme.secondary,
              size: 5.w,
            ),
            SizedBox(width: 2.w),
            Text(
              "Edit Catatan",
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.secondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      onDismissed: (direction) {
        _showActionSheet(context, payment);
      },
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          border: Border.all(
            color: AppTheme.lightTheme.dividerColor,
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeline indicator
            Column(
              children: [
                Container(
                  width: 3.w,
                  height: 3.w,
                  decoration: BoxDecoration(
                    color: _getStatusColor(status),
                    shape: BoxShape.circle,
                  ),
                ),
                if (index < paymentHistory.length - 1)
                  Container(
                    width: 0.5.w,
                    height: 8.h,
                    color: AppTheme.lightTheme.dividerColor,
                    margin: EdgeInsets.only(top: 1.h),
                  ),
              ],
            ),
            SizedBox(width: 4.w),

            // Payment details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        date != null ? _formatDate(date) : "N/A",
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: _getStatusColor(status).withValues(alpha: 0.1),
                          borderRadius:
                              BorderRadius.circular(AppTheme.radiusSmall),
                        ),
                        child: Text(
                          _getStatusText(status),
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: _getStatusColor(status),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    _formatCurrency(amount),
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (note.isNotEmpty) ...[
                    SizedBox(height: 1.h),
                    Text(
                      note,
                      style: AppTheme.lightTheme.textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (proofImage != null) ...[
                    SizedBox(height: 1.h),
                    GestureDetector(
                      onTap: () => onViewProof(proofImage),
                      child: Row(
                        children: [
                          Container(
                            width: 12.w,
                            height: 12.w,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(AppTheme.radiusSmall),
                              border: Border.all(
                                color: AppTheme.lightTheme.dividerColor,
                                width: 1,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(AppTheme.radiusSmall),
                              child: CustomImageWidget(
                                imageUrl: proofImage,
                                width: 12.w,
                                height: 12.w,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            "Bukti Pembayaran",
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showActionSheet(BuildContext context, Map<String, dynamic> payment) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppTheme.radiusLarge),
        ),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              "Aksi Pembayaran",
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
            SizedBox(height: 2.h),
            if (payment["proofImage"] != null)
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'visibility',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 6.w,
                ),
                title: Text("Lihat Bukti"),
                subtitle: Text("Tampilkan foto bukti pembayaran"),
                onTap: () {
                  Navigator.pop(context);
                  onViewProof(payment["proofImage"] as String);
                },
              ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'edit',
                color: AppTheme.lightTheme.colorScheme.secondary,
                size: 6.w,
              ),
              title: Text("Edit Catatan"),
              subtitle: Text("Ubah catatan pembayaran"),
              onTap: () {
                Navigator.pop(context);
                onEditNote(payment);
              },
            ),
            SizedBox(height: 2.h),
          ],
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'paid':
        return AppTheme.successLight;
      case 'pending':
        return AppTheme.warningLight;
      case 'failed':
        return AppTheme.lightTheme.colorScheme.error;
      default:
        return AppTheme.lightTheme.colorScheme.outline;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'paid':
        return "Selesai";
      case 'pending':
        return "Menunggu";
      case 'failed':
        return "Gagal";
      default:
        return "Unknown";
    }
  }
}
