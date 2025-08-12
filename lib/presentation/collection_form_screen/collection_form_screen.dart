import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './widgets/camera_section_widget.dart';
import './widgets/collection_notes_widget.dart';
import './widgets/gps_section_widget.dart';
import './widgets/member_info_widget.dart';
import './widgets/payment_amount_widget.dart';
import './widgets/visit_outcome_widget.dart';

class CollectionFormScreen extends StatefulWidget {
  const CollectionFormScreen({Key? key}) : super(key: key);

  @override
  State<CollectionFormScreen> createState() => _CollectionFormScreenState();
}

class _CollectionFormScreenState extends State<CollectionFormScreen> {
  // Form data
  String _paymentAmount = '';
  XFile? _capturedImage;
  double? _latitude;
  double? _longitude;
  String _collectionNotes = '';
  String? _selectedOutcome;
  DateTime? _agreementDate;

  // Form validation
  bool _isSubmitting = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Mock member data
  final Map<String, dynamic> _memberData = {
    "id": 1,
    "name": "Siti Nurhaliza",
    "group": "Kelompok Makmur Sejahtera",
    "village": "Desa Sukamaju",
    "phone": "081234567890",
    "debt_amount": "Rp 2.500.000,00",
    "overdue_days": 45,
    "last_payment": "15 Juni 2024",
    "payment_history": [
      {"date": "15 Juni 2024", "amount": "Rp 500.000,00", "status": "Lunas"},
      {"date": "15 Mei 2024", "amount": "Rp 750.000,00", "status": "Lunas"}
    ]
  };

  @override
  void initState() {
    super.initState();
    // Initialize with current timestamp for realistic feel
    final now = DateTime.now();
    debugPrint('Collection form initialized at: ${now.toString()}');
  }

  void _onPaymentAmountChanged(String amount) {
    setState(() {
      _paymentAmount = amount;
    });
  }

  void _onImageCaptured(XFile? image) {
    setState(() {
      _capturedImage = image;
    });
  }

  void _onLocationCaptured(double? latitude, double? longitude) {
    setState(() {
      _latitude = latitude;
      _longitude = longitude;
    });
  }

  void _onNotesChanged(String notes) {
    setState(() {
      _collectionNotes = notes;
    });
  }

  void _onOutcomeChanged(String outcome) {
    setState(() {
      _selectedOutcome = outcome;
      // Clear agreement date if not "janji_bayar"
      if (outcome != 'janji_bayar') {
        _agreementDate = null;
      }
    });
  }

  void _onAgreementDateChanged(DateTime? date) {
    setState(() {
      _agreementDate = date;
    });
  }

  bool _validateForm() {
    // Check required fields
    if (_capturedImage == null) {
      _showErrorMessage('Foto bukti pembayaran wajib diambil');
      return false;
    }

    if (_latitude == null || _longitude == null) {
      _showErrorMessage('Lokasi GPS wajib diaktifkan');
      return false;
    }

    if (_selectedOutcome == null) {
      _showErrorMessage('Pilih hasil kunjungan');
      return false;
    }

    if (_selectedOutcome == 'janji_bayar' && _agreementDate == null) {
      _showErrorMessage('Tanggal kesepakatan wajib dipilih untuk janji bayar');
      return false;
    }

    // Validate payment amount for payment outcomes
    if ((_selectedOutcome == 'pembayaran_penuh' ||
            _selectedOutcome == 'pembayaran_sebagian') &&
        _paymentAmount.isEmpty) {
      _showErrorMessage('Jumlah pembayaran wajib diisi');
      return false;
    }

    return true;
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.errorLight,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
      ),
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.successLight,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (!_validateForm()) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Haptic feedback
      HapticFeedback.mediumImpact();

      // Simulate API submission
      await Future.delayed(Duration(seconds: 2));

      // Success feedback
      HapticFeedback.heavyImpact();
      _showSuccessMessage('Data kunjungan berhasil disimpan');

      // Navigate back after short delay
      await Future.delayed(Duration(seconds: 1));
      if (mounted) {
        Navigator.pop(context, true); // Return success result
      }
    } catch (e) {
      _showErrorMessage('Gagal menyimpan data. Silakan coba lagi.');
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Future<bool> _onWillPop() async {
    // Check if form has data
    final hasData = _paymentAmount.isNotEmpty ||
        _capturedImage != null ||
        _collectionNotes.isNotEmpty ||
        _selectedOutcome != null;

    if (!hasData) return true;

    // Show confirmation dialog
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Batalkan Pengisian?',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Data yang sudah diisi akan hilang. Apakah Anda yakin ingin membatalkan?',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Lanjut Isi'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.errorLight,
            ),
            child: Text('Ya, Batalkan'),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text('Form Kunjungan'),
          leading: IconButton(
            onPressed: () async {
              final shouldPop = await _onWillPop();
              if (shouldPop && mounted) {
                Navigator.pop(context);
              }
            },
            icon: CustomIconWidget(
              iconName: 'close',
              color: AppTheme.lightTheme.appBarTheme.foregroundColor!,
              size: 24,
            ),
          ),
          actions: [
            TextButton(
              onPressed: _isSubmitting ? null : _submitForm,
              child: _isSubmitting
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      'Simpan',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
            SizedBox(width: 2.w),
          ],
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Member Information
                MemberInfoWidget(
                  memberName: _memberData['name'],
                  debtAmount: _memberData['debt_amount'],
                ),

                SizedBox(height: 4.h),

                // Payment Amount
                PaymentAmountWidget(
                  onAmountChanged: _onPaymentAmountChanged,
                  initialAmount: _paymentAmount.isEmpty ? null : _paymentAmount,
                ),

                SizedBox(height: 4.h),

                // Camera Section
                CameraSectionWidget(
                  onImageCaptured: _onImageCaptured,
                  capturedImage: _capturedImage,
                ),

                SizedBox(height: 4.h),

                // GPS Section
                GpsSectionWidget(
                  onLocationCaptured: _onLocationCaptured,
                  latitude: _latitude,
                  longitude: _longitude,
                ),

                SizedBox(height: 4.h),

                // Collection Notes
                CollectionNotesWidget(
                  onNotesChanged: _onNotesChanged,
                  initialNotes:
                      _collectionNotes.isEmpty ? null : _collectionNotes,
                ),

                SizedBox(height: 4.h),

                // Visit Outcome
                VisitOutcomeWidget(
                  onOutcomeChanged: _onOutcomeChanged,
                  onAgreementDateChanged: _onAgreementDateChanged,
                  selectedOutcome: _selectedOutcome,
                  agreementDate: _agreementDate,
                ),

                SizedBox(height: 6.h),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 2.5.h),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusMedium),
                      ),
                    ),
                    child: _isSubmitting
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 3.w),
                              Text(
                                'Menyimpan...',
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          )
                        : Text(
                            'Simpan Data Kunjungan',
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),

                SizedBox(height: 4.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
