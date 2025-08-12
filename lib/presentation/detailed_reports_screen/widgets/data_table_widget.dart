import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DataTableWidget extends StatefulWidget {
  final List<Map<String, dynamic>> data;
  final Function(Map<String, dynamic>) onRowTap;

  const DataTableWidget({
    super.key,
    required this.data,
    required this.onRowTap,
  });

  @override
  State<DataTableWidget> createState() => _DataTableWidgetState();
}

class _DataTableWidgetState extends State<DataTableWidget> {
  String _sortColumn = 'date';
  bool _sortAscending = false;
  List<Map<String, dynamic>> _sortedData = [];

  @override
  void initState() {
    super.initState();
    _sortedData = List.from(widget.data);
    _sortData();
  }

  @override
  void didUpdateWidget(covariant DataTableWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data) {
      _sortedData = List.from(widget.data);
      _sortData();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_sortedData.isEmpty) {
      return _buildEmptyState();
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 1.5,
        child: DataTable(
          sortColumnIndex: _getColumnIndex(_sortColumn),
          sortAscending: _sortAscending,
          headingRowColor: WidgetStateProperty.all(
            AppTheme.lightTheme.colorScheme.primaryContainer
                .withValues(alpha: 0.1),
          ),
          columns: [
            DataColumn(
              label: Text(
                'Tanggal',
                style: AppTheme.lightTheme.textTheme.titleSmall,
              ),
              onSort: (columnIndex, ascending) => _sort('date', ascending),
            ),
            DataColumn(
              label: Text(
                'Kolektor',
                style: AppTheme.lightTheme.textTheme.titleSmall,
              ),
              onSort: (columnIndex, ascending) => _sort('collector', ascending),
            ),
            DataColumn(
              label: Text(
                'Member',
                style: AppTheme.lightTheme.textTheme.titleSmall,
              ),
              onSort: (columnIndex, ascending) => _sort('member', ascending),
            ),
            DataColumn(
              label: Text(
                'Jumlah',
                style: AppTheme.lightTheme.textTheme.titleSmall,
              ),
              numeric: true,
              onSort: (columnIndex, ascending) => _sort('amount', ascending),
            ),
            DataColumn(
              label: Text(
                'Status',
                style: AppTheme.lightTheme.textTheme.titleSmall,
              ),
              onSort: (columnIndex, ascending) => _sort('status', ascending),
            ),
            DataColumn(
              label: Text(
                'Aksi',
                style: AppTheme.lightTheme.textTheme.titleSmall,
              ),
            ),
          ],
          rows: _sortedData.map((row) {
            return DataRow(
              cells: [
                DataCell(
                  Text(
                    _formatDate(row['date']),
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                ),
                DataCell(
                  Text(
                    row['collector'],
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                ),
                DataCell(
                  Text(
                    row['member'],
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                ),
                DataCell(
                  Text(
                    'Rp ${_formatCurrency(row['amount'])}',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                DataCell(
                  _buildStatusChip(row['status']),
                ),
                DataCell(
                  IconButton(
                    icon: CustomIconWidget(
                      iconName: 'visibility',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 5.w,
                    ),
                    onPressed: () => widget.onRowTap(row),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'search_off',
            color:
                AppTheme.lightTheme.textTheme.bodySmall?.color ?? Colors.grey,
            size: 20.w,
          ),
          SizedBox(height: 3.h),
          Text(
            'Tidak Ada Data',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.lightTheme.textTheme.bodySmall?.color,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Tidak ada data yang sesuai dengan filter yang dipilih',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.textTheme.bodySmall?.color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color backgroundColor;
    Color textColor;

    switch (status) {
      case 'Lunas':
        backgroundColor = AppTheme.successLight.withValues(alpha: 0.1);
        textColor = AppTheme.successLight;
        break;
      case 'Tertunda':
        backgroundColor = AppTheme.warningLight.withValues(alpha: 0.1);
        textColor = AppTheme.warningLight;
        break;
      case 'Gagal':
        backgroundColor = AppTheme.errorLight.withValues(alpha: 0.1);
        textColor = AppTheme.errorLight;
        break;
      default:
        backgroundColor =
            AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.1);
        textColor =
            AppTheme.lightTheme.textTheme.bodyMedium?.color ?? Colors.grey;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
      ),
      child: Text(
        status,
        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _sort(String column, bool ascending) {
    setState(() {
      _sortColumn = column;
      _sortAscending = ascending;
      _sortData();
    });
  }

  void _sortData() {
    _sortedData.sort((a, b) {
      dynamic aValue = a[_sortColumn];
      dynamic bValue = b[_sortColumn];

      if (_sortColumn == 'date') {
        aValue = DateTime.parse(aValue);
        bValue = DateTime.parse(bValue);
      }

      int comparison;
      if (aValue is DateTime && bValue is DateTime) {
        comparison = aValue.compareTo(bValue);
      } else if (aValue is double && bValue is double) {
        comparison = aValue.compareTo(bValue);
      } else {
        comparison = aValue.toString().compareTo(bValue.toString());
      }

      return _sortAscending ? comparison : -comparison;
    });
  }

  int _getColumnIndex(String column) {
    switch (column) {
      case 'date':
        return 0;
      case 'collector':
        return 1;
      case 'member':
        return 2;
      case 'amount':
        return 3;
      case 'status':
        return 4;
      default:
        return 0;
    }
  }

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatCurrency(double amount) {
    return amount.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }
}
