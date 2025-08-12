import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/achievement_section_widget.dart';
import './widgets/action_buttons_widget.dart';
import './widgets/collection_trends_chart_widget.dart';
import './widgets/monthly_targets_widget.dart';
import './widgets/payment_type_chart_widget.dart';
import './widgets/performance_summary_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/recent_activity_widget.dart';

class ProfileAnalysisScreen extends StatefulWidget {
  const ProfileAnalysisScreen({super.key});

  @override
  State<ProfileAnalysisScreen> createState() => _ProfileAnalysisScreenState();
}

class _ProfileAnalysisScreenState extends State<ProfileAnalysisScreen> {
  bool _isLoading = false;
  bool _isRefreshing = false;

  // Mock collector data
  final Map<String, dynamic> _collectorData = {
    "id": "COL001",
    "name": "Ahmad Fauzi",
    "role": "Field Collector",
    "profilePhoto":
        "https://images.pexels.com/photos/1040880/pexels-photo-1040880.jpeg?auto=compress&cs=tinysrgb&w=400",
    "joinDate": DateTime(2023, 6, 15),
    "totalCollections": 156,
    "successRate": 87.5,
    "avgVisitTime": 45,
    "teamRanking": 2,
    "totalTeamMembers": 8,
  };

  // Mock performance data
  final Map<String, dynamic> _performanceData = {
    "thisMonth": {
      "collections": 23,
      "successRate": 91.3,
      "avgVisitTime": 42,
      "ranking": 1,
    },
    "weeklyTrends": [
      {"week": "W1", "collections": 6, "success": 5},
      {"week": "W2", "collections": 8, "success": 7},
      {"week": "W3", "collections": 5, "success": 5},
      {"week": "W4", "collections": 4, "success": 4},
    ],
    "paymentTypes": [
      {"type": "Tunai", "value": 65.0, "color": 0xFF2E7D32},
      {"type": "Transfer", "value": 25.0, "color": 0xFF8D6E63},
      {"type": "E-Wallet", "value": 10.0, "color": 0xFFFF6F00},
    ],
    "monthlyTarget": {
      "target": 30,
      "achieved": 23,
      "remaining": 7,
      "daysLeft": 8,
      "progressPercentage": 76.7,
    },
  };

  // Mock achievements data
  final List<Map<String, dynamic>> _achievements = [
    {
      "id": "ACH001",
      "title": "First 100 Collections",
      "description": "Berhasil menyelesaikan 100 kunjungan pertama",
      "icon": "trophy",
      "isEarned": true,
      "earnedDate": DateTime(2024, 3, 20),
    },
    {
      "id": "ACH002",
      "title": "Perfect Week",
      "description": "Mencapai target 100% dalam satu minggu",
      "icon": "star",
      "isEarned": true,
      "earnedDate": DateTime(2024, 6, 15),
    },
    {
      "id": "ACH003",
      "title": "Monthly Champion",
      "description": "Ranking #1 tim dalam satu bulan",
      "icon": "medal",
      "isEarned": false,
      "progress": 85.0,
      "requirement": "Capai ranking #1 tim",
    },
  ];

  // Mock recent activity
  final List<Map<String, dynamic>> _recentActivity = [
    {
      "id": "VIS001",
      "date": DateTime(2024, 7, 22, 14, 30),
      "memberName": "Siti Nurhaliza",
      "amount": 500000.0,
      "outcome": "success",
      "note": "Pembayaran tunai, cicilan bulan Juli",
    },
    {
      "id": "VIS002",
      "date": DateTime(2024, 7, 22, 10, 15),
      "memberName": "Budi Santoso",
      "amount": 0.0,
      "outcome": "no_payment",
      "note": "Akan membayar minggu depan",
    },
    {
      "id": "VIS003",
      "date": DateTime(2024, 7, 21, 16, 45),
      "memberName": "Dewi Sartika",
      "amount": 250000.0,
      "outcome": "partial",
      "note": "Pembayaran sebagian, sisanya minggu depan",
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
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 1.h),

              // Profile Header
              ProfileHeaderWidget(
                collectorData: _collectorData,
                onEditProfile: _editProfile,
              ),

              // Performance Summary Cards
              PerformanceSummaryWidget(
                performanceData:
                    _performanceData["thisMonth"] as Map<String, dynamic>,
              ),

              // Collection Trends Chart
              CollectionTrendsChartWidget(
                weeklyData: _performanceData["weeklyTrends"]
                    as List<Map<String, dynamic>>,
              ),

              // Payment Type Distribution Chart
              PaymentTypeChartWidget(
                paymentTypes: _performanceData["paymentTypes"]
                    as List<Map<String, dynamic>>,
              ),

              // Achievement Section
              AchievementSectionWidget(
                achievements: _achievements,
              ),

              // Monthly Targets
              MonthlyTargetsWidget(
                targetData:
                    _performanceData["monthlyTarget"] as Map<String, dynamic>,
              ),

              // Recent Activity Timeline
              RecentActivityWidget(
                activities: _recentActivity,
                onViewDetail: _viewActivityDetail,
              ),

              // Bottom Action Buttons
              ActionButtonsWidget(
                onViewFullReport: _viewFullReport,
                onShareAchievements: _shareAchievements,
                isLoading: _isLoading,
              ),

              SizedBox(height: 2.h),
            ],
          ),
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
            "Analisis Performa",
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            _collectorData["name"] as String? ?? "Collector",
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onPrimary
                  .withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleRefresh() async {
    setState(() => _isRefreshing = true);

    // Simulate API call to refresh analytics data
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isRefreshing = false);

    if (mounted) {
      // Haptic feedback for refresh
      // HapticFeedback.lightImpact();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Data analisis berhasil diperbarui"),
          backgroundColor: AppTheme.successLight,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          ),
        ),
      );
    }
  }

  void _editProfile() {
    // Navigate to edit profile screen or show edit dialog
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Fitur edit profil akan segera tersedia"),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        ),
      ),
    );
  }

  void _viewActivityDetail(Map<String, dynamic> activity) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppTheme.radiusLarge),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        builder: (context, scrollController) => Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
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
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Detail Kunjungan",
                        style: AppTheme.lightTheme.textTheme.titleLarge,
                      ),
                      SizedBox(height: 2.h),
                      _buildActivityDetailItem(
                        "Tanggal",
                        _formatDateTime(activity["date"] as DateTime),
                      ),
                      _buildActivityDetailItem(
                        "Member",
                        activity["memberName"] as String,
                      ),
                      _buildActivityDetailItem(
                        "Jumlah Pembayaran",
                        activity["amount"] == 0.0
                            ? "Tidak ada pembayaran"
                            : _formatCurrency(activity["amount"] as double),
                      ),
                      _buildActivityDetailItem(
                        "Hasil",
                        _getOutcomeText(activity["outcome"] as String),
                      ),
                      _buildActivityDetailItem(
                        "Catatan",
                        activity["note"] as String? ?? "Tidak ada catatan",
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityDetailItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  void _viewFullReport() async {
    setState(() => _isLoading = true);

    try {
      // Simulate report generation
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Laporan lengkap berhasil dibuat"),
            backgroundColor: AppTheme.successLight,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gagal membuat laporan. Coba lagi."),
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

  void _shareAchievements() {
    // Implement share achievements functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Fitur bagikan pencapaian akan segera tersedia"),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
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

  String _formatDateTime(DateTime dateTime) {
    return "${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
  }

  String _getOutcomeText(String outcome) {
    switch (outcome) {
      case 'success':
        return 'Berhasil';
      case 'partial':
        return 'Sebagian';
      case 'no_payment':
        return 'Tidak Ada Pembayaran';
      default:
        return 'Tidak Diketahui';
    }
  }
}
