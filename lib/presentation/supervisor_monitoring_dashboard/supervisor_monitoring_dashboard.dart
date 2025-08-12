import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/bulk_actions_sheet_widget.dart';
import './widgets/collector_card_widget.dart';
import './widgets/dashboard_header_widget.dart';
import './widgets/filter_chips_widget.dart';

class SupervisorMonitoringDashboard extends StatefulWidget {
  const SupervisorMonitoringDashboard({super.key});

  @override
  State<SupervisorMonitoringDashboard> createState() =>
      _SupervisorMonitoringDashboardState();
}

class _SupervisorMonitoringDashboardState
    extends State<SupervisorMonitoringDashboard> with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'all';
  bool _isRefreshing = false;
  List<Map<String, dynamic>> _collectors = [];
  List<Map<String, dynamic>> _filteredCollectors = [];

  final List<Map<String, dynamic>> _mockCollectors = [
    {
      "id": 1,
      "name": "Ahmad Rizki Pratama",
      "profilePhoto":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "status": "Active",
      "visitCount": 8,
      "amountCollected": 2500000.0,
      "lastActivity": "10 menit yang lalu",
      "location": {"lat": -6.2088, "lng": 106.8456},
      "performance": 85.5,
      "village": "Desa Sukamaju"
    },
    {
      "id": 2,
      "name": "Siti Nurhaliza",
      "profilePhoto":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "status": "Active",
      "visitCount": 6,
      "amountCollected": 1800000.0,
      "lastActivity": "25 menit yang lalu",
      "location": {"lat": -6.1751, "lng": 106.8650},
      "performance": 78.2,
      "village": "Desa Makmur"
    },
    {
      "id": 3,
      "name": "Budi Santoso",
      "profilePhoto":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "status": "Idle",
      "visitCount": 4,
      "amountCollected": 950000.0,
      "lastActivity": "1 jam yang lalu",
      "location": {"lat": -6.2297, "lng": 106.8467},
      "performance": 65.8,
      "village": "Desa Sejahtera"
    },
    {
      "id": 4,
      "name": "Dewi Kartika Sari",
      "profilePhoto":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "status": "Active",
      "visitCount": 9,
      "amountCollected": 3200000.0,
      "lastActivity": "5 menit yang lalu",
      "location": {"lat": -6.1944, "lng": 106.8229},
      "performance": 92.1,
      "village": "Desa Maju Bersama"
    },
    {
      "id": 5,
      "name": "Eko Prasetyo",
      "profilePhoto":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "status": "Offline",
      "visitCount": 2,
      "amountCollected": 450000.0,
      "lastActivity": "3 jam yang lalu",
      "location": {"lat": -6.2615, "lng": 106.7809},
      "performance": 45.3,
      "village": "Desa Harapan"
    },
    {
      "id": 6,
      "name": "Maya Indira Putri",
      "profilePhoto":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "status": "Active",
      "visitCount": 7,
      "amountCollected": 2100000.0,
      "lastActivity": "15 menit yang lalu",
      "location": {"lat": -6.1754, "lng": 106.8272},
      "performance": 81.7,
      "village": "Desa Berkah"
    },
    {
      "id": 7,
      "name": "Rudi Hermawan",
      "profilePhoto":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "status": "Idle",
      "visitCount": 3,
      "amountCollected": 720000.0,
      "lastActivity": "45 menit yang lalu",
      "location": {"lat": -6.2441, "lng": 106.8096},
      "performance": 58.9,
      "village": "Desa Mandiri"
    },
    {
      "id": 8,
      "name": "Lestari Wulandari",
      "profilePhoto":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "status": "Active",
      "visitCount": 5,
      "amountCollected": 1650000.0,
      "lastActivity": "20 menit yang lalu",
      "location": {"lat": -6.2146, "lng": 106.8451},
      "performance": 74.6,
      "village": "Desa Sentosa"
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _collectors = List.from(_mockCollectors);
    _filteredCollectors = List.from(_collectors);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Column(
        children: [
          DashboardHeaderWidget(
            activeCollectorsCount: _getActiveCollectorsCount(),
            onRefresh: _handleRefresh,
            isRefreshing: _isRefreshing,
          ),

          // Tab Bar
          Container(
            color: AppTheme.lightTheme.colorScheme.surface,
            child: TabBar(
              controller: _tabController,
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'monitor',
                        color: _tabController.index == 0
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.textTheme.bodySmall?.color ??
                                Colors.grey,
                        size: 5.w,
                      ),
                      SizedBox(width: 2.w),
                      Text('Monitoring'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'analytics',
                        color: _tabController.index == 1
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.textTheme.bodySmall?.color ??
                                Colors.grey,
                        size: 5.w,
                      ),
                      SizedBox(width: 2.w),
                      Text('Analytics'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'settings',
                        color: _tabController.index == 2
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.textTheme.bodySmall?.color ??
                                Colors.grey,
                        size: 5.w,
                      ),
                      SizedBox(width: 2.w),
                      Text('Settings'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Tab Bar View
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildMonitoringTab(),
                _buildAnalyticsTab(),
                _buildSettingsTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton.extended(
              onPressed: _showBulkActionsSheet,
              icon: CustomIconWidget(
                iconName: 'more_horiz',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 6.w,
              ),
              label: Text(
                'Aksi Massal',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildMonitoringTab() {
    return Column(
      children: [
        SizedBox(height: 2.h),

        // Filter Chips
        FilterChipsWidget(
          selectedFilter: _selectedFilter,
          onFilterChanged: _handleFilterChanged,
        ),

        SizedBox(height: 2.h),

        // Collectors List
        Expanded(
          child: RefreshIndicator(
            onRefresh: _handleRefresh,
            color: AppTheme.lightTheme.colorScheme.primary,
            child: _filteredCollectors.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: EdgeInsets.only(bottom: 10.h),
                    itemCount: _filteredCollectors.length,
                    itemBuilder: (context, index) {
                      final collector = _filteredCollectors[index];
                      return CollectorCardWidget(
                        collector: collector,
                        onTap: () => _navigateToCollectorDetail(collector),
                        onViewRoute: () => _handleViewRoute(collector),
                        onSendMessage: () => _handleSendMessage(collector),
                        onViewReport: () => _handleViewReport(collector),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnalyticsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'analytics',
            color:
                AppTheme.lightTheme.textTheme.bodySmall?.color ?? Colors.grey,
            size: 20.w,
          ),
          SizedBox(height: 3.h),
          Text(
            'Analytics Dashboard',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.lightTheme.textTheme.bodySmall?.color,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Fitur analytics akan segera hadir',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.textTheme.bodySmall?.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'settings',
            color:
                AppTheme.lightTheme.textTheme.bodySmall?.color ?? Colors.grey,
            size: 20.w,
          ),
          SizedBox(height: 3.h),
          Text(
            'Pengaturan',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.lightTheme.textTheme.bodySmall?.color,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Fitur pengaturan akan segera hadir',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.textTheme.bodySmall?.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'people_outline',
            color:
                AppTheme.lightTheme.textTheme.bodySmall?.color ?? Colors.grey,
            size: 20.w,
          ),
          SizedBox(height: 3.h),
          Text(
            'Tidak Ada Kolektor',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.lightTheme.textTheme.bodySmall?.color,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Belum ada kolektor yang sesuai dengan filter yang dipilih',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.textTheme.bodySmall?.color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  int _getActiveCollectorsCount() {
    return _collectors
        .where((collector) =>
            (collector['status'] as String).toLowerCase() == 'active')
        .length;
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
      // In real app, this would update with fresh data from API
      _collectors = List.from(_mockCollectors);
      _applyFilter();
    });
  }

  void _handleFilterChanged(String filter) {
    setState(() {
      _selectedFilter = filter;
      _applyFilter();
    });
  }

  void _applyFilter() {
    setState(() {
      switch (_selectedFilter) {
        case 'performance':
          _filteredCollectors = _collectors
              .where(
                  (collector) => (collector['performance'] as double) >= 80.0)
              .toList();
          break;
        case 'location':
          _filteredCollectors = _collectors
              .where((collector) =>
                  (collector['village'] as String).contains('Desa'))
              .toList();
          break;
        case 'status':
          _filteredCollectors = _collectors
              .where((collector) =>
                  (collector['status'] as String).toLowerCase() == 'active')
              .toList();
          break;
        case 'all':
        default:
          _filteredCollectors = List.from(_collectors);
          break;
      }
    });
  }

  void _navigateToCollectorDetail(Map<String, dynamic> collector) {
    // Navigate to detailed collector activity view
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Membuka detail untuk ${collector['name']}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleViewRoute(Map<String, dynamic> collector) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Melihat rute ${collector['name']}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleSendMessage(Map<String, dynamic> collector) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Mengirim pesan ke ${collector['name']}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleViewReport(Map<String, dynamic> collector) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Melihat laporan ${collector['name']}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showBulkActionsSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppTheme.radiusLarge)),
      ),
      builder: (context) => BulkActionsSheetWidget(
        onSendNotifications: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Mengirim notifikasi ke semua kolektor'),
              duration: Duration(seconds: 2),
            ),
          );
        },
        onGenerateReports: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Generating laporan kinerja'),
              duration: Duration(seconds: 2),
            ),
          );
        },
        onScheduleMeetings: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Menjadwalkan rapat tim'),
              duration: Duration(seconds: 2),
            ),
          );
        },
      ),
    );
  }
}
