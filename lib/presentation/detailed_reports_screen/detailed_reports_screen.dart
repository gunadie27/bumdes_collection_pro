import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/collection_trends_chart_widget.dart';
import './widgets/data_table_widget.dart';
import './widgets/date_range_picker_widget.dart';
import './widgets/export_options_widget.dart';
import './widgets/filter_section_widget.dart';
import './widgets/metrics_cards_widget.dart';
import './widgets/payment_distribution_chart_widget.dart';

class DetailedReportsScreen extends StatefulWidget {
  const DetailedReportsScreen({super.key});

  @override
  State<DetailedReportsScreen> createState() => _DetailedReportsScreenState();
}

class _DetailedReportsScreenState extends State<DetailedReportsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();
  String _selectedCollector = 'all';
  String _selectedVillage = 'all';
  String _selectedPaymentStatus = 'all';
  String _selectedAmountRange = 'all';
  bool _isLoading = false;
  String _searchQuery = '';

  final List<Map<String, dynamic>> _mockReportsData = [
    {
      "id": 1,
      "date": "2025-01-15",
      "collector": "Ahmad Rizki",
      "member": "Budi Santoso",
      "amount": 500000.0,
      "status": "Lunas",
      "village": "Desa Sukamaju",
      "paymentType": "Tunai",
      "notes": "Pembayaran tepat waktu"
    },
    {
      "id": 2,
      "date": "2025-01-14",
      "collector": "Siti Nurhaliza",
      "member": "Dewi Kartika",
      "amount": 750000.0,
      "status": "Tertunda",
      "village": "Desa Makmur",
      "paymentType": "Transfer",
      "notes": "Janji bayar minggu depan"
    },
    {
      "id": 3,
      "date": "2025-01-13",
      "collector": "Maya Indira",
      "member": "Eko Prasetyo",
      "amount": 300000.0,
      "status": "Lunas",
      "village": "Desa Berkah",
      "paymentType": "Tunai",
      "notes": "Pembayaran sebagian"
    },
    {
      "id": 4,
      "date": "2025-01-12",
      "collector": "Ahmad Rizki",
      "member": "Lestari Wulan",
      "amount": 1200000.0,
      "status": "Gagal",
      "village": "Desa Sukamaju",
      "paymentType": "Transfer",
      "notes": "Member tidak ditemui"
    },
    {
      "id": 5,
      "date": "2025-01-11",
      "collector": "Dewi Kartika",
      "member": "Rudi Hermawan",
      "amount": 950000.0,
      "status": "Lunas",
      "village": "Desa Maju Bersama",
      "paymentType": "Tunai",
      "notes": "Pembayaran lunas"
    }
  ];

  List<Map<String, dynamic>> _filteredReports = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _filteredReports = List.from(_mockReportsData);
    _loadReportsData();
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
      appBar: AppBar(
        title: const Text('Laporan Detail'),
        elevation: 0,
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'refresh',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 6.w,
            ),
            onPressed: _refreshData,
          ),
          IconButton(
            icon: CustomIconWidget(
              iconName: 'download',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 6.w,
            ),
            onPressed: _showExportOptions,
          ),
        ],
      ),
      body: Column(
        children: [
          // Date Range Picker
          DateRangePickerWidget(
            startDate: _startDate,
            endDate: _endDate,
            onDateRangeChanged: (start, end) {
              setState(() {
                _startDate = start;
                _endDate = end;
              });
              _loadReportsData();
            },
          ),

          // Metrics Cards
          MetricsCardsWidget(
            totalCollections: _calculateTotalCollections(),
            successRate: _calculateSuccessRate(),
            averageVisitTime: _calculateAverageVisitTime(),
            outstandingAmount: _calculateOutstandingAmount(),
          ),

          // Tab Bar
          Container(
            color: AppTheme.lightTheme.colorScheme.surface,
            child: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Dashboard'),
                Tab(text: 'Grafik'),
                Tab(text: 'Data'),
              ],
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildDashboardTab(),
                _buildChartsTab(),
                _buildDataTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter Section
          FilterSectionWidget(
            selectedCollector: _selectedCollector,
            selectedVillage: _selectedVillage,
            selectedPaymentStatus: _selectedPaymentStatus,
            selectedAmountRange: _selectedAmountRange,
            onCollectorChanged: (value) {
              setState(() {
                _selectedCollector = value;
              });
              _applyFilters();
            },
            onVillageChanged: (value) {
              setState(() {
                _selectedVillage = value;
              });
              _applyFilters();
            },
            onPaymentStatusChanged: (value) {
              setState(() {
                _selectedPaymentStatus = value;
              });
              _applyFilters();
            },
            onAmountRangeChanged: (value) {
              setState(() {
                _selectedAmountRange = value;
              });
              _applyFilters();
            },
          ),

          SizedBox(height: 3.h),

          // Quick Stats
          Row(
            children: [
              Expanded(
                child: _buildQuickStatCard(
                  'Total Penagihan',
                  _filteredReports.length.toString(),
                  Icons.assignment,
                  AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildQuickStatCard(
                  'Berhasil',
                  _filteredReports
                      .where((r) => r['status'] == 'Lunas')
                      .length
                      .toString(),
                  Icons.check_circle,
                  AppTheme.successLight,
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          Row(
            children: [
              Expanded(
                child: _buildQuickStatCard(
                  'Tertunda',
                  _filteredReports
                      .where((r) => r['status'] == 'Tertunda')
                      .length
                      .toString(),
                  Icons.schedule,
                  AppTheme.warningLight,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildQuickStatCard(
                  'Gagal',
                  _filteredReports
                      .where((r) => r['status'] == 'Gagal')
                      .length
                      .toString(),
                  Icons.error,
                  AppTheme.errorLight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          // Collection Trends Chart
          Card(
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tren Penagihan',
                    style: AppTheme.lightTheme.textTheme.titleMedium,
                  ),
                  SizedBox(height: 2.h),
                  SizedBox(
                    height: 30.h,
                    child: CollectionTrendsChartWidget(
                      data: _getCollectionTrendsData(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 2.h),

          // Payment Distribution Chart
          Card(
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Distribusi Jenis Pembayaran',
                    style: AppTheme.lightTheme.textTheme.titleMedium,
                  ),
                  SizedBox(height: 2.h),
                  SizedBox(
                    height: 30.h,
                    child: PaymentDistributionChartWidget(
                      data: _getPaymentDistributionData(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTab() {
    return Column(
      children: [
        // Search Bar
        Padding(
          padding: EdgeInsets.all(4.w),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Cari berdasarkan nama member, kolektor, atau ID...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _searchQuery = '';
                        });
                        _applyFilters();
                      },
                    )
                  : null,
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
              _applyFilters();
            },
          ),
        ),

        // Data Table
        Expanded(
          child: DataTableWidget(
            data: _filteredReports,
            onRowTap: _showRowDetails,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStatCard(
      String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          children: [
            Icon(icon, color: color, size: 8.w),
            SizedBox(height: 1.h),
            Text(
              value,
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  double _calculateTotalCollections() {
    return _filteredReports
        .where((r) => r['status'] == 'Lunas')
        .fold(0.0, (sum, item) => sum + (item['amount'] as double));
  }

  double _calculateSuccessRate() {
    if (_filteredReports.isEmpty) return 0.0;
    final successful =
        _filteredReports.where((r) => r['status'] == 'Lunas').length;
    return (successful / _filteredReports.length) * 100;
  }

  String _calculateAverageVisitTime() {
    return "15 menit"; // Mock data
  }

  double _calculateOutstandingAmount() {
    return _filteredReports
        .where((r) => r['status'] != 'Lunas')
        .fold(0.0, (sum, item) => sum + (item['amount'] as double));
  }

  List<FlSpot> _getCollectionTrendsData() {
    // Mock data for line chart
    return [
      const FlSpot(1, 1000000),
      const FlSpot(2, 1500000),
      const FlSpot(3, 2000000),
      const FlSpot(4, 1800000),
      const FlSpot(5, 2200000),
      const FlSpot(6, 2500000),
      const FlSpot(7, 2800000),
    ];
  }

  Map<String, double> _getPaymentDistributionData() {
    final Map<String, double> distribution = {};
    for (var report in _filteredReports) {
      final paymentType = report['paymentType'] as String;
      distribution[paymentType] = (distribution[paymentType] ?? 0) + 1;
    }
    return distribution;
  }

  Future<void> _loadReportsData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
      _filteredReports = List.from(_mockReportsData);
    });
    _applyFilters();
  }

  void _applyFilters() {
    setState(() {
      _filteredReports = _mockReportsData.where((report) {
        bool matchesCollector = _selectedCollector == 'all' ||
            report['collector'].toString().contains(_selectedCollector);
        bool matchesVillage = _selectedVillage == 'all' ||
            report['village'].toString().contains(_selectedVillage);
        bool matchesStatus = _selectedPaymentStatus == 'all' ||
            report['status'] == _selectedPaymentStatus;
        bool matchesSearch = _searchQuery.isEmpty ||
            report['member']
                .toString()
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            report['collector']
                .toString()
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            report['id'].toString().contains(_searchQuery);

        return matchesCollector &&
            matchesVillage &&
            matchesStatus &&
            matchesSearch;
      }).toList();
    });
  }

  Future<void> _refreshData() async {
    await _loadReportsData();
  }

  void _showExportOptions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppTheme.radiusLarge)),
      ),
      builder: (context) => ExportOptionsWidget(
        onExportPDF: _exportToPDF,
        onExportExcel: _exportToExcel,
        onEmailReport: _emailReport,
      ),
    );
  }

  void _showRowDetails(Map<String, dynamic> rowData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Detail Transaksi #${rowData['id']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Tanggal', rowData['date']),
            _buildDetailRow('Kolektor', rowData['collector']),
            _buildDetailRow('Member', rowData['member']),
            _buildDetailRow(
                'Jumlah', 'Rp ${rowData['amount'].toStringAsFixed(0)}'),
            _buildDetailRow('Status', rowData['status']),
            _buildDetailRow('Desa', rowData['village']),
            _buildDetailRow('Jenis Pembayaran', rowData['paymentType']),
            _buildDetailRow('Catatan', rowData['notes']),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 30.w,
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

  void _exportToPDF() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mengekspor laporan ke PDF...')),
    );
  }

  void _exportToExcel() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mengekspor laporan ke Excel...')),
    );
  }

  void _emailReport() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mengirim laporan via email...')),
    );
  }
}
