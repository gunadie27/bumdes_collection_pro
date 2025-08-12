import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class VisitOutcomeWidget extends StatefulWidget {
  final Function(String) onOutcomeChanged;
  final Function(DateTime?) onAgreementDateChanged;
  final String? selectedOutcome;
  final DateTime? agreementDate;

  const VisitOutcomeWidget({
    Key? key,
    required this.onOutcomeChanged,
    required this.onAgreementDateChanged,
    this.selectedOutcome,
    this.agreementDate,
  }) : super(key: key);

  @override
  State<VisitOutcomeWidget> createState() => _VisitOutcomeWidgetState();
}

class _VisitOutcomeWidgetState extends State<VisitOutcomeWidget> {
  final List<Map<String, dynamic>> _outcomes = [
    {
      'value': 'pembayaran_penuh',
      'label': 'Pembayaran Penuh',
      'icon': 'check_circle',
      'color': AppTheme.successLight,
      'description': 'Anggota melunasi seluruh tunggakan',
    },
    {
      'value': 'pembayaran_sebagian',
      'label': 'Pembayaran Sebagian',
      'icon': 'partial_fulfillment',
      'color': AppTheme.warningLight,
      'description': 'Anggota membayar sebagian tunggakan',
    },
    {
      'value': 'janji_bayar',
      'label': 'Janji Bayar',
      'icon': 'schedule',
      'color': AppTheme.lightTheme.colorScheme.primary,
      'description': 'Anggota berjanji akan membayar pada tanggal tertentu',
    },
    {
      'value': 'tidak_bertemu',
      'label': 'Tidak Bertemu',
      'icon': 'person_off',
      'color': AppTheme.lightTheme.colorScheme.onSurfaceVariant,
      'description': 'Anggota tidak ada di tempat atau tidak dapat ditemui',
    },
  ];

  Future<void> _selectAgreementDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          widget.agreementDate ?? DateTime.now().add(Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
      locale: Locale('id', 'ID'),
      builder: (context, child) {
        return DatePickerTheme(
          data: DatePickerThemeData(
            backgroundColor: AppTheme.lightTheme.colorScheme.surface,
            headerBackgroundColor: AppTheme.lightTheme.colorScheme.primary,
            headerForegroundColor: Colors.white,
            dayForegroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return Colors.white;
              }
              return AppTheme.lightTheme.colorScheme.onSurface;
            }),
            dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return AppTheme.lightTheme.colorScheme.primary;
              }
              return Colors.transparent;
            }),
            todayForegroundColor: WidgetStateProperty.all(
              AppTheme.lightTheme.colorScheme.primary,
            ),
            todayBackgroundColor: WidgetStateProperty.all(
              AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
            ),
            confirmButtonStyle: TextButton.styleFrom(
              foregroundColor: AppTheme.lightTheme.colorScheme.primary,
            ),
            cancelButtonStyle: TextButton.styleFrom(
              foregroundColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      widget.onAgreementDateChanged(picked);
    }
  }

  String _formatDate(DateTime date) {
    final months = [
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

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'assignment_turned_in',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 3.w),
              Text(
                'Hasil Kunjungan',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                ' *',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  color: AppTheme.errorLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Outcome Options
          Column(
            children: _outcomes.map((outcome) {
              final isSelected = widget.selectedOutcome == outcome['value'];

              return Container(
                margin: EdgeInsets.only(bottom: 2.h),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => widget.onOutcomeChanged(outcome['value']),
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (outcome['color'] as Color).withValues(alpha: 0.1)
                            : AppTheme
                                .lightTheme.colorScheme.surfaceContainerHighest,
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusMedium),
                        border: Border.all(
                          color: isSelected
                              ? (outcome['color'] as Color)
                              : AppTheme.lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.2),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(2.w),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? (outcome['color'] as Color)
                                  : AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant
                                      .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: CustomIconWidget(
                              iconName: outcome['icon'],
                              color: isSelected
                                  ? Colors.white
                                  : AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                              size: 20,
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  outcome['label'],
                                  style: AppTheme
                                      .lightTheme.textTheme.titleSmall
                                      ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? (outcome['color'] as Color)
                                        : AppTheme
                                            .lightTheme.colorScheme.onSurface,
                                  ),
                                ),
                                SizedBox(height: 0.5.h),
                                Text(
                                  outcome['description'],
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color: AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            CustomIconWidget(
                              iconName: 'check_circle',
                              color: outcome['color'],
                              size: 24,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          // Agreement Date Picker (only show if "Janji Bayar" is selected)
          if (widget.selectedOutcome == 'janji_bayar') ...[
            SizedBox(height: 2.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'event',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 18,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Tanggal Kesepakatan Pembayaran',
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        ' *',
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          color: AppTheme.errorLight,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _selectAgreementDate,
                      borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.surface,
                          borderRadius:
                              BorderRadius.circular(AppTheme.radiusSmall),
                          border: Border.all(
                            color: AppTheme.lightTheme.colorScheme.outline,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'calendar_today',
                              color: AppTheme.lightTheme.colorScheme.primary,
                              size: 18,
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: Text(
                                widget.agreementDate != null
                                    ? _formatDate(widget.agreementDate!)
                                    : 'Pilih tanggal kesepakatan',
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color: widget.agreementDate != null
                                      ? AppTheme
                                          .lightTheme.colorScheme.onSurface
                                      : AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant
                                          .withValues(alpha: 0.6),
                                ),
                              ),
                            ),
                            CustomIconWidget(
                              iconName: 'arrow_drop_down',
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
