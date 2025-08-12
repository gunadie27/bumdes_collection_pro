import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/agreement_calendar_widget.dart';
import './widgets/agreement_card_widget.dart';
import './widgets/agreement_search_widget.dart';
import './widgets/agreement_tabs_widget.dart';
import './widgets/bulk_reminder_widget.dart';

class AgreementTrackingScreen extends StatefulWidget {
  const AgreementTrackingScreen({super.key});

  @override
  State<AgreementTrackingScreen> createState() =>
      _AgreementTrackingScreenState();
}

class _AgreementTrackingScreenState extends State<AgreementTrackingScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _currentTab = 'Aktif';
  bool _isLoading = false;
  String _searchQuery = '';
  List<Map<String, dynamic>> _agreements = [];
  List<Map<String, dynamic>> _filteredAgreements = [];

  final List<Map<String, dynamic>> _mockAgreements = [
    {
      "id": 1,
      "memberName": "Budi Santoso",
      "memberPhoto":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "promisedAmount": 500000.0,
      "originalDebt": 1200000.0,
      "dueDate": "2025-01-20",
      "status": "Aktif",
      "priority": "high",
      "contactNumber": "081234567890",
      "village": "Desa Sukamaju",
      "notes": "Janji bayar setelah panen",
      "createdDate": "2025-01-10",
      "lastContact": "2025-01-15"
    },
    {
      "id": 2,
      "memberName": "Siti Nurhaliza",
      "memberPhoto":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "promisedAmount": 750000.0,
      "originalDebt": 1500000.0,
      "dueDate": "2025-01-18",
      "status": "Jatuh Tempo",
      "priority": "urgent",
      "contactNumber": "081234567891",
      "village": "Desa Makmur",
      "notes": "Sudah terlambat 2 hari",
      "createdDate": "2025-01-08",
      "lastContact": "2025-01-16"
    },
    {
      "id": 3,
      "memberName": "Dewi Kartika",
      "memberPhoto":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "promisedAmount": 300000.0,
      "originalDebt": 600000.0,
      "dueDate": "2025-01-25",
      "status": "Aktif",
      "priority": "medium",
      "contactNumber": "081234567892",
      "village": "Desa Berkah",
      "notes": "Pembayaran bertahap",
      "createdDate": "2025-01-12",
      "lastContact": "2025-01-14"
    },
    {
      "id": 4,
      "memberName": "Eko Prasetyo",
      "memberPhoto":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "promisedAmount": 1000000.0,
      "originalDebt": 1000000.0,
      "dueDate": "2025-01-10",
      "status": "Selesai",
      "priority": "completed",
      "contactNumber": "081234567893",
      "village": "Desa Maju",
      "notes": "Lunas tepat waktu",
      "createdDate": "2025-01-05",
      "lastContact": "2025-01-10"
    },
    {
      "id": 5,
      "memberName": "Maya Indira",
      "memberPhoto":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "promisedAmount": 450000.0,
      "originalDebt": 900000.0,
      "dueDate": "2025-01-22",
      "status": "Aktif",
      "priority": "low",
      "contactNumber": "081234567894",
      "village": "Desa Sentosa",
      "notes": "Cicilan kedua",
      "createdDate": "2025-01-11",
      "lastContact": "2025-01-13"
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabChange);
    _agreements = List.from(_mockAgreements);
    _applyFilters();
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (!_tabController.indexIsChanging) {
      setState(() {
        _currentTab = ['Aktif', 'Jatuh Tempo', 'Selesai'][_tabController.index];
      });
      _applyFilters();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Perjanjian'),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(10.h),
          child: Column(
            children: [
              // Search Bar
              AgreementSearchWidget(
                searchQuery: _searchQuery,
                onSearchChanged: (query) {
                  setState(() {
                    _searchQuery = query;
                  });
                  _applyFilters();
                },
              ),
              // Tab Bar
              AgreementTabsWidget(
                tabController: _tabController,
                activeCount: _getActiveCount(),
                overdueCount: _getOverdueCount(),
                completedCount: _getCompletedCount(),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'calendar_today',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 6.w,
            ),
            onPressed: _showCalendarView,
          ),
          IconButton(
            icon: CustomIconWidget(
              iconName: 'refresh',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 6.w,
            ),
            onPressed: _refreshData,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAgreementsList('Aktif'),
                _buildAgreementsList('Jatuh Tempo'),
                _buildAgreementsList('Selesai'),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _currentTab != 'Selesai'
          ? FloatingActionButton.extended(
              onPressed: _showBulkActions,
              icon: CustomIconWidget(
                iconName: 'notifications',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 5.w,
              ),
              label: Text(
                'Kirim Reminder',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildAgreementsList(String status) {
    final agreements = _filteredAgreements
        .where((agreement) => agreement['status'] == status)
        .toList();

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (agreements.isEmpty) {
      return _buildEmptyState(status);
    }

    return RefreshIndicator(
      onRefresh: _refreshData,
      color: AppTheme.lightTheme.colorScheme.primary,
      child: ListView.builder(
        padding: EdgeInsets.all(4.w),
        itemCount: agreements.length,
        itemBuilder: (context, index) {
          final agreement = agreements[index];
          return AgreementCardWidget(
            agreement: agreement,
            onTap: () => _showAgreementDetail(agreement),
            onContact: () => _contactMember(agreement),
            onReschedule: () => _rescheduleAgreement(agreement),
            onMarkCompleted: () => _markAsCompleted(agreement),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(String status) {
    String title;
    String description;
    IconData icon;

    switch (status) {
      case 'Aktif':
        title = 'Tidak Ada Perjanjian Aktif';
        description = 'Belum ada perjanjian pembayaran yang sedang berjalan';
        icon = Icons.assignment;
        break;
      case 'Jatuh Tempo':
        title = 'Tidak Ada yang Jatuh Tempo';
        description =
            'Semua perjanjian masih dalam batas waktu yang ditentukan';
        icon = Icons.schedule;
        break;
      case 'Selesai':
        title = 'Belum Ada yang Selesai';
        description = 'Belum ada perjanjian yang diselesaikan';
        icon = Icons.check_circle;
        break;
      default:
        title = 'Tidak Ada Data';
        description = 'Tidak ada data untuk ditampilkan';
        icon = Icons.inbox;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 20.w,
            color:
                AppTheme.lightTheme.textTheme.bodySmall?.color ?? Colors.grey,
          ),
          SizedBox(height: 3.h),
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.lightTheme.textTheme.bodySmall?.color,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            description,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.textTheme.bodySmall?.color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  int _getActiveCount() {
    return _agreements.where((a) => a['status'] == 'Aktif').length;
  }

  int _getOverdueCount() {
    return _agreements.where((a) => a['status'] == 'Jatuh Tempo').length;
  }

  int _getCompletedCount() {
    return _agreements.where((a) => a['status'] == 'Selesai').length;
  }

  void _applyFilters() {
    setState(() {
      _filteredAgreements = _agreements.where((agreement) {
        bool matchesSearch = _searchQuery.isEmpty ||
            agreement['memberName']
                .toString()
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            agreement['village']
                .toString()
                .toLowerCase()
                .contains(_searchQuery.toLowerCase());

        return matchesSearch;
      }).toList();
    });
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
      _agreements = List.from(_mockAgreements);
    });
    _applyFilters();
  }

  void _showAgreementDetail(Map<String, dynamic> agreement) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppTheme.radiusLarge)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          padding: EdgeInsets.all(6.w),
          child: ListView(
            controller: scrollController,
            children: [
              // Header
              Row(
                children: [
                  CircleAvatar(
                    radius: 8.w,
                    backgroundImage: NetworkImage(agreement['memberPhoto']),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          agreement['memberName'],
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          agreement['village'],
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color:
                                AppTheme.lightTheme.textTheme.bodySmall?.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildPriorityChip(agreement['priority']),
                ],
              ),

              SizedBox(height: 4.h),

              // Agreement Details
              _buildDetailCard(agreement),

              SizedBox(height: 3.h),

              // Action Buttons
              if (agreement['status'] != 'Selesai') ...[
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _contactMember(agreement);
                        },
                        icon: const Icon(Icons.phone),
                        label: const Text('Hubungi'),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _rescheduleAgreement(agreement);
                        },
                        icon: const Icon(Icons.schedule),
                        label: const Text('Reschedule'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _markAsCompleted(agreement);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.successLight,
                    ),
                    icon: const Icon(Icons.check_circle),
                    label: const Text('Tandai Lunas'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailCard(Map<String, dynamic> agreement) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Jumlah Janji',
                'Rp ${_formatCurrency(agreement['promisedAmount'])}'),
            _buildDetailRow('Total Hutang',
                'Rp ${_formatCurrency(agreement['originalDebt'])}'),
            _buildDetailRow(
                'Tanggal Jatuh Tempo', _formatDate(agreement['dueDate'])),
            _buildDetailRow(
                'Tanggal Dibuat', _formatDate(agreement['createdDate'])),
            _buildDetailRow(
                'Kontak Terakhir', _formatDate(agreement['lastContact'])),
            _buildDetailRow('Catatan', agreement['notes']),
            if (_isOverdue(agreement['dueDate'])) ...[
              SizedBox(height: 2.h),
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.errorLight.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  border: Border.all(
                      color: AppTheme.errorLight.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning,
                      color: AppTheme.errorLight,
                      size: 5.w,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        'Perjanjian sudah jatuh tempo ${_getDaysOverdue(agreement['dueDate'])} hari',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.errorLight,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 35.w,
            child: Text(
              '$label:',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityChip(String priority) {
    Color color;
    String label;

    switch (priority) {
      case 'urgent':
        color = AppTheme.errorLight;
        label = 'Mendesak';
        break;
      case 'high':
        color = AppTheme.warningLight;
        label = 'Tinggi';
        break;
      case 'medium':
        color = AppTheme.lightTheme.colorScheme.primary;
        label = 'Sedang';
        break;
      case 'low':
        color = AppTheme.successLight;
        label = 'Rendah';
        break;
      case 'completed':
        color = AppTheme.successLight;
        label = 'Selesai';
        break;
      default:
        color = AppTheme.lightTheme.colorScheme.outline;
        label = 'Normal';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _contactMember(Map<String, dynamic> agreement) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Menghubungi ${agreement['memberName']}...'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _rescheduleAgreement(Map<String, dynamic> agreement) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Menjadwal ulang perjanjian ${agreement['memberName']}...'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _markAsCompleted(Map<String, dynamic> agreement) {
    setState(() {
      final index = _agreements.indexWhere((a) => a['id'] == agreement['id']);
      if (index != -1) {
        _agreements[index]['status'] = 'Selesai';
        _agreements[index]['priority'] = 'completed';
      }
    });
    _applyFilters();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Perjanjian ${agreement['memberName']} telah diselesaikan'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showBulkActions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppTheme.radiusLarge)),
      ),
      builder: (context) => BulkReminderWidget(
        onSendReminders: _sendBulkReminders,
        onScheduleReminders: _scheduleBulkReminders,
        onGenerateReport: _generateAgreementReport,
      ),
    );
  }

  void _showCalendarView() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: AgreementCalendarWidget(
          agreements: _agreements,
          onDateSelected: (selectedDate) {
            Navigator.pop(context);
            // Filter by selected date
          },
        ),
      ),
    );
  }

  void _sendBulkReminders() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Mengirim reminder ke semua member...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _scheduleBulkReminders() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Menjadwalkan reminder otomatis...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _generateAgreementReport() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Membuat laporan perjanjian...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  String _formatCurrency(double amount) {
    return amount.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    return '${date.day}/${date.month}/${date.year}';
  }

  bool _isOverdue(String dueDateString) {
    final dueDate = DateTime.parse(dueDateString);
    final now = DateTime.now();
    return now.isAfter(dueDate);
  }

  int _getDaysOverdue(String dueDateString) {
    final dueDate = DateTime.parse(dueDateString);
    final now = DateTime.now();
    return now.difference(dueDate).inDays;
  }
}
