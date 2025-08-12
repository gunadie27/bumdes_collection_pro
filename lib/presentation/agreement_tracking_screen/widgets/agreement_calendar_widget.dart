import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class AgreementCalendarWidget extends StatefulWidget {
  final List<Map<String, dynamic>> agreements;
  final Function(DateTime) onDateSelected;

  const AgreementCalendarWidget({
    super.key,
    required this.agreements,
    required this.onDateSelected,
  });

  @override
  State<AgreementCalendarWidget> createState() =>
      _AgreementCalendarWidgetState();
}

class _AgreementCalendarWidgetState extends State<AgreementCalendarWidget> {
  late DateTime _currentMonth;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime.now();
    _selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      width: 90.w,
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Kalender Perjanjian',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Month Navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: _previousMonth,
              ),
              Text(
                _getMonthYearString(_currentMonth),
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: _nextMonth,
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Calendar Grid
          Expanded(
            child: _buildCalendarGrid(),
          ),

          SizedBox(height: 2.h),

          // Legend
          _buildLegend(),

          SizedBox(height: 2.h),

          // Selected Date Agreements
          if (_getAgreementsForDate(_selectedDate).isNotEmpty) ...[
            Text(
              'Perjanjian pada ${_formatDate(_selectedDate)}:',
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Container(
              height: 15.h,
              child: ListView.builder(
                itemCount: _getAgreementsForDate(_selectedDate).length,
                itemBuilder: (context, index) {
                  final agreement = _getAgreementsForDate(_selectedDate)[index];
                  return _buildAgreementItem(agreement);
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth =
        DateTime(_currentMonth.year, _currentMonth.month, 1);
    final lastDayOfMonth =
        DateTime(_currentMonth.year, _currentMonth.month + 1, 0);
    final firstDayWeekday = firstDayOfMonth.weekday;
    final daysInMonth = lastDayOfMonth.day;

    return Column(
      children: [
        // Weekday headers
        Row(
          children: ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min']
              .map((day) => Expanded(
                    child: Center(
                      child: Text(
                        day,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.lightTheme.textTheme.bodySmall?.color,
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),

        SizedBox(height: 1.h),

        // Calendar days
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1,
            ),
            itemCount: 42, // 6 weeks * 7 days
            itemBuilder: (context, index) {
              final dayNumber = index - firstDayWeekday + 2;

              if (dayNumber <= 0 || dayNumber > daysInMonth) {
                return Container(); // Empty cell
              }

              final date =
                  DateTime(_currentMonth.year, _currentMonth.month, dayNumber);
              final agreements = _getAgreementsForDate(date);
              final isSelected = _isSameDay(date, _selectedDate);
              final isToday = _isSameDay(date, DateTime.now());

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDate = date;
                  });
                  widget.onDateSelected(date);
                },
                child: Container(
                  margin: EdgeInsets.all(1.w),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                        : isToday
                            ? AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.1)
                            : null,
                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                    border: isToday && !isSelected
                        ? Border.all(
                            color: AppTheme.lightTheme.colorScheme.primary)
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        dayNumber.toString(),
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: isSelected
                              ? Colors.white
                              : AppTheme.lightTheme.textTheme.bodyMedium?.color,
                          fontWeight:
                              isToday ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      if (agreements.isNotEmpty) ...[
                        SizedBox(height: 0.5.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: agreements.take(3).map((agreement) {
                            return Container(
                              width: 1.5.w,
                              height: 1.5.w,
                              margin: EdgeInsets.symmetric(horizontal: 0.5.w),
                              decoration: BoxDecoration(
                                color: _getAgreementColor(agreement),
                                shape: BoxShape.circle,
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildLegendItem('Aktif', AppTheme.lightTheme.colorScheme.primary),
        _buildLegendItem('Jatuh Tempo', AppTheme.errorLight),
        _buildLegendItem('Selesai', AppTheme.successLight),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 3.w,
          height: 3.w,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 1.w),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildAgreementItem(Map<String, dynamic> agreement) {
    return Container(
      padding: EdgeInsets.all(2.w),
      margin: EdgeInsets.only(bottom: 1.h),
      decoration: BoxDecoration(
        color: _getAgreementColor(agreement).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        border: Border.all(
          color: _getAgreementColor(agreement).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  agreement['memberName'],
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Rp ${_formatCurrency(agreement['promisedAmount'])}',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.textTheme.bodySmall?.color,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              color: _getAgreementColor(agreement),
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            ),
            child: Text(
              agreement['status'],
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getAgreementsForDate(DateTime date) {
    return widget.agreements.where((agreement) {
      final dueDate = DateTime.parse(agreement['dueDate']);
      return _isSameDay(date, dueDate);
    }).toList();
  }

  Color _getAgreementColor(Map<String, dynamic> agreement) {
    switch (agreement['status']) {
      case 'Aktif':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'Jatuh Tempo':
        return AppTheme.errorLight;
      case 'Selesai':
        return AppTheme.successLight;
      default:
        return AppTheme.lightTheme.colorScheme.outline;
    }
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  String _getMonthYearString(DateTime date) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatCurrency(double amount) {
    return amount.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
  }
}
