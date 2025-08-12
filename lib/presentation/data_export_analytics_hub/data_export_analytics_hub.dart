import 'dart:convert';
import 'dart:html' as html if (dart.library.html) 'dart:html';
import 'dart:io' if (dart.library.io) 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart'
    if (dart.library.io) 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column;

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/advanced_filter_widget.dart';
import './widgets/analytics_dashboard_widget.dart';
import './widgets/date_range_selector_widget.dart';
import './widgets/export_queue_widget.dart';
import './widgets/export_section_widget.dart';
import './widgets/scheduled_exports_widget.dart';
import './widgets/security_options_widget.dart';

class DataExportAnalyticsHub extends StatefulWidget {
  const DataExportAnalyticsHub({super.key});

  @override
  State<DataExportAnalyticsHub> createState() => _DataExportAnalyticsHubState();
}

class _DataExportAnalyticsHubState extends State<DataExportAnalyticsHub>
    with TickerProviderStateMixin {
  bool _isLoading = false;
  int _selectedTabIndex = 0;

  // Date range state
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();
  String _selectedPreset = 'monthly';

  // Filter state
  Map<String, dynamic> _activeFilters = {};

  // Export queue
  List<Map<String, dynamic>> _exportQueue = [];

  // Analytics data
  final Map<String, dynamic> _analyticsData = {
    'collectionTrends': [
      {'month': 'Jan', 'collections': 450, 'amount': 125000000},
      {'month': 'Feb', 'collections': 520, 'amount': 140000000},
      {'month': 'Mar', 'collections': 480, 'amount': 135000000},
      {'month': 'Apr', 'collections': 610, 'amount': 165000000},
      {'month': 'May', 'collections': 580, 'amount': 158000000},
      {'month': 'Jun', 'collections': 640, 'amount': 172000000},
    ],
    'collectorPerformance': [
      {'name': 'Ahmad Fauzi', 'collections': 89, 'successRate': 92.5},
      {'name': 'Siti Nurhaliza', 'collections': 76, 'successRate': 88.2},
      {'name': 'Budi Santoso', 'collections': 82, 'successRate': 90.1},
      {'name': 'Dewi Sartika', 'collections': 73, 'successRate': 87.8},
    ],
    'geographicalData': [
      {'village': 'Desa Maju', 'collections': 145, 'amount': 42000000},
      {'village': 'Desa Sejahtera', 'collections': 132, 'amount': 38500000},
      {'village': 'Desa Berkah', 'collections': 108, 'amount': 31200000},
      {'village': 'Desa Makmur', 'collections': 95, 'amount': 28800000},
    ],
    'paymentPatterns': [
      {'type': 'Tunai', 'percentage': 65.0, 'color': 0xFF2E7D32},
      {'type': 'Transfer Bank', 'percentage': 25.0, 'color': 0xFF8D6E63},
      {'type': 'E-Wallet', 'percentage': 10.0, 'color': 0xFFFF6F00},
    ],
  };

  // Tab controller
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadInitialData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    setState(() => _isLoading = true);

    // Simulate loading analytics data
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: _isLoading ? _buildLoadingState() : _buildMainContent(),
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
      title: Text(
        "Ekspor Data",
        style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      bottom: TabBar(
        controller: _tabController,
        indicatorColor: AppTheme.lightTheme.colorScheme.onPrimary,
        labelColor: AppTheme.lightTheme.colorScheme.onPrimary,
        unselectedLabelColor:
            AppTheme.lightTheme.colorScheme.onPrimary.withValues(alpha: 0.7),
        tabs: const [
          Tab(text: "Ekspor"),
          Tab(text: "Analitik"),
          Tab(text: "Terjadwal"),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppTheme.lightTheme.colorScheme.primary,
          ),
          SizedBox(height: 2.h),
          Text(
            "Memuat data analytics...",
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildExportTab(),
        _buildAnalyticsTab(),
        _buildScheduledTab(),
      ],
    );
  }

  Widget _buildExportTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date Range Selector
          DateRangeSelectorWidget(
            startDate: _startDate,
            endDate: _endDate,
            selectedPreset: _selectedPreset,
            onDateRangeChanged: (start, end, preset) {
              setState(() {
                _startDate = start;
                _endDate = end;
                _selectedPreset = preset;
              });
            },
          ),

          SizedBox(height: 2.h),

          // Advanced Filters
          AdvancedFilterWidget(
            activeFilters: _activeFilters,
            onFiltersChanged: (filters) {
              setState(() => _activeFilters = filters);
            },
          ),

          SizedBox(height: 3.h),

          // Export Sections
          Text(
            "Kategori Ekspor",
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),

          // Collection Reports
          ExportSectionWidget(
            title: "Laporan Penagihan",
            subtitle: "Data kunjungan dan hasil penagihan",
            icon: 'assignment',
            exportFormats: ['PDF', 'Excel', 'CSV'],
            onExport: (format) => _handleExport('collection_reports', format),
          ),

          SizedBox(height: 2.h),

          // Performance Analytics
          ExportSectionWidget(
            title: "Analisis Performa",
            subtitle: "Statistik dan ranking collector",
            icon: 'analytics',
            exportFormats: ['PDF', 'Excel'],
            onExport: (format) =>
                _handleExport('performance_analytics', format),
          ),

          SizedBox(height: 2.h),

          // Member Data
          ExportSectionWidget(
            title: "Data Member",
            subtitle: "Informasi lengkap member dan tunggakan",
            icon: 'people',
            exportFormats: ['Excel', 'CSV'],
            onExport: (format) => _handleExport('member_data', format),
          ),

          SizedBox(height: 2.h),

          // Financial Summaries
          ExportSectionWidget(
            title: "Ringkasan Keuangan",
            subtitle: "Laporan keuangan dan cash flow",
            icon: 'account_balance',
            exportFormats: ['PDF', 'Excel'],
            onExport: (format) => _handleExport('financial_summaries', format),
          ),

          SizedBox(height: 3.h),

          // Export Queue
          if (_exportQueue.isNotEmpty) ...[
            ExportQueueWidget(
              exportQueue: _exportQueue,
              onCancelExport: _cancelExport,
              onRetryExport: _retryExport,
            ),
            SizedBox(height: 2.h),
          ],

          // Security Options
          SecurityOptionsWidget(
            onPasswordProtection: _togglePasswordProtection,
            onAuditTrail: _viewAuditTrail,
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          AnalyticsDashboardWidget(
            analyticsData: _analyticsData,
            onInteraction: _handleAnalyticsInteraction,
          ),
        ],
      ),
    );
  }

  Widget _buildScheduledTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          ScheduledExportsWidget(
            onCreateSchedule: _createScheduledExport,
            onEditSchedule: _editScheduledExport,
            onDeleteSchedule: _deleteScheduledExport,
          ),
        ],
      ),
    );
  }

  Future<void> _handleExport(String category, String format) async {
    // Add to export queue
    final exportTask = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'category': category,
      'format': format,
      'status': 'processing',
      'progress': 0.0,
      'startTime': DateTime.now(),
      'estimatedCompletion': DateTime.now().add(const Duration(minutes: 5)),
    };

    setState(() {
      _exportQueue.add(exportTask);
    });

    try {
      // Simulate export processing
      for (int i = 0; i <= 100; i += 10) {
        await Future.delayed(const Duration(milliseconds: 300));

        setState(() {
          final index =
              _exportQueue.indexWhere((task) => task['id'] == exportTask['id']);
          if (index != -1) {
            _exportQueue[index]['progress'] = i.toDouble();
          }
        });
      }

      // Generate actual file
      await _generateExportFile(category, format, exportTask['id'] as String);

      // Update status to completed
      setState(() {
        final index =
            _exportQueue.indexWhere((task) => task['id'] == exportTask['id']);
        if (index != -1) {
          _exportQueue[index]['status'] = 'completed';
          _exportQueue[index]['progress'] = 100.0;
        }
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text("Ekspor ${_getCategoryName(category)} ($format) berhasil"),
            backgroundColor: AppTheme.successLight,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            ),
          ),
        );
      }
    } catch (e) {
      // Update status to failed
      setState(() {
        final index =
            _exportQueue.indexWhere((task) => task['id'] == exportTask['id']);
        if (index != -1) {
          _exportQueue[index]['status'] = 'failed';
        }
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gagal mengekspor ${_getCategoryName(category)}"),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            ),
          ),
        );
      }
    }
  }

  Future<void> _generateExportFile(
      String category, String format, String taskId) async {
    final data = _getExportData(category);
    final filename =
        '${category}_${DateTime.now().millisecondsSinceEpoch}.$format';

    switch (format.toLowerCase()) {
      case 'csv':
        await _generateCSV(data, filename);
        break;
      case 'excel':
        await _generateExcel(data, filename);
        break;
      case 'pdf':
        await _generatePDF(data, filename);
        break;
    }
  }

  Future<void> _generateCSV(
      List<Map<String, dynamic>> data, String filename) async {
    if (data.isEmpty) return;

    final headers = data.first.keys.toList();
    final rows = data
        .map(
            (item) => headers.map((header) => item[header].toString()).toList())
        .toList();
    final csvData = [headers, ...rows];
    final csvString = const ListToCsvConverter().convert(csvData);

    await _saveFile(csvString, filename);
  }

  Future<void> _generateExcel(
      List<Map<String, dynamic>> data, String filename) async {
    final workbook = Workbook();
    final worksheet = workbook.worksheets[0];

    if (data.isNotEmpty) {
      final headers = data.first.keys.toList();

      // Write headers
      for (int i = 0; i < headers.length; i++) {
        worksheet.getRangeByIndex(1, i + 1).setText(headers[i]);
      }

      // Write data
      for (int row = 0; row < data.length; row++) {
        for (int col = 0; col < headers.length; col++) {
          worksheet
              .getRangeByIndex(row + 2, col + 1)
              .setText(data[row][headers[col]].toString());
        }
      }
    }

    final bytes = workbook.saveAsStream();
    await _saveFileBytes(bytes, filename);
    workbook.dispose();
  }

  Future<void> _generatePDF(
      List<Map<String, dynamic>> data, String filename) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Data Export Report',
                style:
                    pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                  'Generated on: ${DateTime.now().toString().split('.')[0]}'),
              pw.SizedBox(height: 20),
              if (data.isNotEmpty) ...[
                pw.Table.fromTextArray(
                  headers: data.first.keys.toList(),
                  data: data
                      .map((item) =>
                          item.values.map((value) => value.toString()).toList())
                      .toList(),
                ),
              ],
            ],
          );
        },
      ),
    );

    final bytes = await pdf.save();
    await _saveFileBytes(bytes, filename);
  }

  Future<void> _saveFile(String content, String filename) async {
    if (kIsWeb) {
      final bytes = utf8.encode(content);
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", filename)
        ..click();
      html.Url.revokeObjectUrl(url);
    } else {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$filename');
      await file.writeAsString(content);

      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Exported data: $filename',
      );
    }
  }

  Future<void> _saveFileBytes(List<int> bytes, String filename) async {
    if (kIsWeb) {
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", filename)
        ..click();
      html.Url.revokeObjectUrl(url);
    } else {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$filename');
      await file.writeAsBytes(bytes);

      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Exported data: $filename',
      );
    }
  }

  List<Map<String, dynamic>> _getExportData(String category) {
    switch (category) {
      case 'collection_reports':
        return [
          {
            'Date': '2024-07-22',
            'Member': 'Siti Nurhaliza',
            'Amount': 500000,
            'Status': 'Paid'
          },
          {
            'Date': '2024-07-22',
            'Member': 'Budi Santoso',
            'Amount': 0,
            'Status': 'No Payment'
          },
          {
            'Date': '2024-07-21',
            'Member': 'Dewi Sartika',
            'Amount': 250000,
            'Status': 'Partial'
          },
        ];
      case 'performance_analytics':
        return _analyticsData['collectorPerformance']
            as List<Map<String, dynamic>>;
      case 'member_data':
        return [
          {
            'Name': 'Ahmad Fauzi',
            'Village': 'Desa Maju',
            'Outstanding': 1500000,
            'LastPayment': '2024-07-15'
          },
          {
            'Name': 'Siti Nurhaliza',
            'Village': 'Desa Sejahtera',
            'Outstanding': 750000,
            'LastPayment': '2024-07-22'
          },
        ];
      case 'financial_summaries':
        return _analyticsData['collectionTrends'] as List<Map<String, dynamic>>;
      default:
        return [];
    }
  }

  String _getCategoryName(String category) {
    switch (category) {
      case 'collection_reports':
        return 'Laporan Penagihan';
      case 'performance_analytics':
        return 'Analisis Performa';
      case 'member_data':
        return 'Data Member';
      case 'financial_summaries':
        return 'Ringkasan Keuangan';
      default:
        return category;
    }
  }

  void _cancelExport(String taskId) {
    setState(() {
      _exportQueue.removeWhere((task) => task['id'] == taskId);
    });
  }

  void _retryExport(String taskId) {
    final task = _exportQueue.firstWhere((task) => task['id'] == taskId);
    _handleExport(task['category'], task['format']);
  }

  void _togglePasswordProtection(bool enabled) {
    // Implement password protection toggle
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(enabled
            ? "Proteksi password diaktifkan"
            : "Proteksi password dinonaktifkan"),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        ),
      ),
    );
  }

  void _viewAuditTrail() {
    // Navigate to audit trail screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Fitur audit trail akan segera tersedia"),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        ),
      ),
    );
  }

  void _handleAnalyticsInteraction(String type, Map<String, dynamic> data) {
    // Handle analytics chart interactions
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Interaksi analytics: $type"),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        ),
      ),
    );
  }

  void _createScheduledExport() {
    // Navigate to create scheduled export screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Fitur jadwal ekspor akan segera tersedia"),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        ),
      ),
    );
  }

  void _editScheduledExport(String scheduleId) {
    // Navigate to edit scheduled export screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Edit jadwal ekspor: $scheduleId"),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        ),
      ),
    );
  }

  void _deleteScheduledExport(String scheduleId) {
    // Delete scheduled export
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Jadwal ekspor dihapus: $scheduleId"),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        ),
      ),
    );
  }
}