import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/action_buttons.dart';
import './widgets/debt_summary_card.dart';
import './widgets/member_info_card.dart';
import './widgets/payment_history_timeline.dart';

class MemberDetailScreen extends StatefulWidget {
  const MemberDetailScreen({super.key});

  @override
  State<MemberDetailScreen> createState() => _MemberDetailScreenState();
}

class _MemberDetailScreenState extends State<MemberDetailScreen> {
  bool _isLoading = false;
  bool _isRefreshing = false;

  // Mock member data
  final Map<String, dynamic> _memberData = {
    "memberId": "BUM001234",
    "name": "Siti Nurhaliza",
    "phone": "+62812-3456-7890",
    "address": "Jl. Merdeka No. 45, RT 02/RW 05, Desa Sukamaju, Kec. Cianjur",
    "photo":
        "https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&w=400",
    "groupName": "Kelompok Makmur Sejahtera",
    "joinDate": DateTime(2023, 3, 15),
  };

  // Mock debt data
  final Map<String, dynamic> _debtData = {
    "originalAmount": 5000000.0,
    "outstandingAmount": 2500000.0,
    "loanDate": DateTime(2024, 1, 15),
    "dueDate": DateTime(2024, 7, 15),
    "overdueDays": 8,
    "interestRate": 2.5,
    "installmentAmount": 500000.0,
  };

  // Mock payment history
  final List<Map<String, dynamic>> _paymentHistory = [
    {
      "id": "PAY001",
      "date": DateTime(2024, 7, 10),
      "amount": 500000.0,
      "status": "completed",
      "note": "Pembayaran cicilan bulan Juli, diterima tunai",
      "proofImage":
          "https://images.pexels.com/photos/164527/pexels-photo-164527.jpeg?auto=compress&cs=tinysrgb&w=400",
      "collectorId": "COL001",
      "collectorName": "Ahmad Fauzi",
    },
    {
      "id": "PAY002",
      "date": DateTime(2024, 6, 12),
      "amount": 500000.0,
      "status": "completed",
      "note": "Pembayaran cicilan bulan Juni, transfer bank",
      "proofImage":
          "https://images.pexels.com/photos/259027/pexels-photo-259027.jpeg?auto=compress&cs=tinysrgb&w=400",
      "collectorId": "COL001",
      "collectorName": "Ahmad Fauzi",
    },
    {
      "id": "PAY003",
      "date": DateTime(2024, 5, 8),
      "amount": 500000.0,
      "status": "completed",
      "note": "Pembayaran cicilan bulan Mei, diterima di kantor",
      "proofImage":
          "https://images.pexels.com/photos/259027/pexels-photo-259027.jpeg?auto=compress&cs=tinysrgb&w=400",
      "collectorId": "COL002",
      "collectorName": "Budi Santoso",
    },
    {
      "id": "PAY004",
      "date": DateTime(2024, 4, 15),
      "amount": 500000.0,
      "status": "completed",
      "note": "Pembayaran cicilan bulan April",
      "proofImage":
          "https://images.pexels.com/photos/164527/pexels-photo-164527.jpeg?auto=compress&cs=tinysrgb&w=400",
      "collectorId": "COL001",
      "collectorName": "Ahmad Fauzi",
    },
    {
      "id": "PAY005",
      "date": DateTime(2024, 3, 20),
      "amount": 500000.0,
      "status": "pending",
      "note": "Pembayaran cicilan bulan Maret, menunggu konfirmasi",
      "proofImage": null,
      "collectorId": "COL001",
      "collectorName": "Ahmad Fauzi",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: AppTheme.lightTheme.colorScheme.primary,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 1.h),

                    // Member Information Card
                    MemberInfoCard(memberData: _memberData),

                    // Debt Summary Card
                    DebtSummaryCard(debtData: _debtData),

                    // Payment History Timeline
                    PaymentHistoryTimeline(
                      paymentHistory: _paymentHistory,
                      onViewProof: _viewProofImage,
                      onEditNote: _editPaymentNote,
                    ),

                    SizedBox(height: 10.h), // Space for bottom buttons
                  ],
                ),
              ),
            ),

            // Bottom Action Buttons
            ActionButtons(
              onStartVisit: _startVisit,
              onContactMember: _contactMember,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
      elevation: AppTheme.elevationLow,
      centerTitle: true,
      leading: IconButton(
        icon: CustomIconWidget(
          iconName: 'arrow_back',
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          size: 6.w,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Column(
        children: [
          Text(
            _memberData["name"] as String? ?? "Detail Member",
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            "ID: ${_memberData["memberId"] as String? ?? "N/A"}",
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onPrimary
                  .withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: CustomIconWidget(
            iconName: 'more_vert',
            color: AppTheme.lightTheme.colorScheme.onPrimary,
            size: 6.w,
          ),
          onPressed: _showMoreOptions,
        ),
      ],
    );
  }

  Future<void> _handleRefresh() async {
    setState(() => _isRefreshing = true);

    // Simulate API call to refresh member data
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isRefreshing = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Data member berhasil diperbarui"),
          backgroundColor: AppTheme.successLight,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          ),
        ),
      );
    }
  }

  void _startVisit() async {
    setState(() => _isLoading = true);

    try {
      // Simulate GPS capture and navigation preparation
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        // Navigate to collection form screen
        Navigator.pushNamed(
          context,
          '/collection-form-screen',
          arguments: {
            'memberData': _memberData,
            'debtData': _debtData,
          },
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gagal memulai kunjungan. Periksa koneksi GPS."),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _contactMember() {
    final phoneNumber = _memberData["phone"] as String?;
    if (phoneNumber == null || phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Nomor telepon tidak tersedia"),
          backgroundColor: AppTheme.warningLight,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          ),
        ),
      );
      return;
    }

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
              "Hubungi ${_memberData["name"]}",
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'phone',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              title: Text("Telepon"),
              subtitle: Text(phoneNumber),
              onTap: () {
                Navigator.pop(context);
                // Implement phone call functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Membuka aplikasi telepon..."),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'message',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              title: Text("SMS"),
              subtitle: Text("Kirim pesan singkat"),
              onTap: () {
                Navigator.pop(context);
                // Implement SMS functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Membuka aplikasi SMS..."),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'chat',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              title: Text("WhatsApp"),
              subtitle: Text("Kirim pesan WhatsApp"),
              onTap: () {
                Navigator.pop(context);
                // Implement WhatsApp functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Membuka WhatsApp..."),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _viewProofImage(String imageUrl) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                panEnabled: true,
                boundaryMargin: EdgeInsets.all(4.w),
                minScale: 0.5,
                maxScale: 3.0,
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: 90.w,
                    maxHeight: 70.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                    child: CustomImageWidget(
                      imageUrl: imageUrl,
                      width: 90.w,
                      height: 70.h,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 4.h,
              right: 4.w,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.7),
                    shape: BoxShape.circle,
                  ),
                  child: CustomIconWidget(
                    iconName: 'close',
                    color: Colors.white,
                    size: 6.w,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _editPaymentNote(Map<String, dynamic> payment) {
    final TextEditingController noteController = TextEditingController(
      text: payment["note"] as String? ?? "",
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit Catatan Pembayaran"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Tanggal: ${_formatDate(payment["date"] as DateTime)}",
              style: AppTheme.lightTheme.textTheme.bodySmall,
            ),
            Text(
              "Jumlah: ${_formatCurrency(payment["amount"] as double)}",
              style: AppTheme.lightTheme.textTheme.bodySmall,
            ),
            SizedBox(height: 2.h),
            TextField(
              controller: noteController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "Catatan",
                hintText: "Masukkan catatan pembayaran...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              // Update payment note
              payment["note"] = noteController.text;
              Navigator.pop(context);
              setState(() {});

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Catatan berhasil diperbarui"),
                  backgroundColor: AppTheme.successLight,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: Text("Simpan"),
          ),
        ],
      ),
    );
  }

  void _showMoreOptions() {
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
              "Opsi Lainnya",
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              title: Text("Bagikan Info Member"),
              onTap: () {
                Navigator.pop(context);
                // Implement share functionality
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'print',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              title: Text("Cetak Laporan"),
              onTap: () {
                Navigator.pop(context);
                // Implement print functionality
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'history',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              title: Text("Riwayat Lengkap"),
              onTap: () {
                Navigator.pop(context);
                // Navigate to full history screen
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
}
