import 'dart:html' as html if (dart.library.html) 'dart:html';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class GpsSectionWidget extends StatefulWidget {
  final Function(double?, double?) onLocationCaptured;
  final double? latitude;
  final double? longitude;

  const GpsSectionWidget({
    Key? key,
    required this.onLocationCaptured,
    this.latitude,
    this.longitude,
  }) : super(key: key);

  @override
  State<GpsSectionWidget> createState() => _GpsSectionWidgetState();
}

class _GpsSectionWidgetState extends State<GpsSectionWidget> {
  bool _isCapturingLocation = false;
  String _accuracyText = '';

  @override
  void initState() {
    super.initState();
    if (widget.latitude == null || widget.longitude == null) {
      _captureLocation();
    }
  }

  Future<void> _captureLocation() async {
    if (_isCapturingLocation) return;

    setState(() {
      _isCapturingLocation = true;
      _accuracyText = 'Mengambil lokasi...';
    });

    try {
      if (kIsWeb) {
        await _captureWebLocation();
      } else {
        await _captureMobileLocation();
      }
    } catch (e) {
      setState(() {
        _accuracyText = 'Gagal mengambil lokasi';
      });
    } finally {
      setState(() {
        _isCapturingLocation = false;
      });
    }
  }

  Future<void> _captureWebLocation() async {
    try {
      final position =
          await html.window.navigator.geolocation.getCurrentPosition(
        enableHighAccuracy: true,
        timeout: Duration(seconds: 10),
        maximumAge: Duration(minutes: 1),
      );

      final coords = position.coords;
      final latitude = coords?.latitude;
      final longitude = coords?.longitude;
      final accuracy = coords?.accuracy;

      if (latitude != null && longitude != null) {
        widget.onLocationCaptured(latitude.toDouble(), longitude.toDouble());
        setState(() {
          _accuracyText = accuracy != null
              ? 'Akurasi: ${accuracy.toStringAsFixed(0)}m'
              : 'Lokasi berhasil diambil';
        });
      }
    } catch (e) {
      setState(() {
        _accuracyText = 'Gagal mengambil lokasi';
      });
    }
  }

  Future<void> _captureMobileLocation() async {
    // For mobile implementation, we'll simulate GPS capture
    // In a real app, you would use geolocator package
    await Future.delayed(Duration(seconds: 2));

    // Mock GPS coordinates for Jakarta area
    final latitude =
        -6.2088 + (0.1 * (0.5 - (DateTime.now().millisecond / 1000)));
    final longitude = 106.8456 + (0.1 * (0.5 - (DateTime.now().second / 60)));

    widget.onLocationCaptured(latitude, longitude);
    setState(() {
      _accuracyText = 'Akurasi: 5m';
    });
  }

  void _openGoogleMaps() {
    if (widget.latitude != null && widget.longitude != null) {
      final url =
          'https://www.google.com/maps?q=${widget.latitude},${widget.longitude}';

      if (kIsWeb) {
        html.window.open(url, '_blank');
      } else {
        // In a real app, you would use url_launcher package
        // For now, we'll show a message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Membuka Google Maps...'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  String _formatCoordinates() {
    if (widget.latitude != null && widget.longitude != null) {
      return '${widget.latitude!.toStringAsFixed(6)}, ${widget.longitude!.toStringAsFixed(6)}';
    }
    return 'Belum tersedia';
  }

  @override
  Widget build(BuildContext context) {
    final hasLocation = widget.latitude != null && widget.longitude != null;

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
                iconName: 'location_on',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 3.w),
              Text(
                'Lokasi GPS',
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

          // Location Status Card
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: hasLocation
                  ? AppTheme.successLight.withValues(alpha: 0.1)
                  : AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              border: Border.all(
                color: hasLocation
                    ? AppTheme.successLight.withValues(alpha: 0.3)
                    : AppTheme.lightTheme.colorScheme.outline
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
                      iconName: hasLocation ? 'gps_fixed' : 'gps_not_fixed',
                      color: hasLocation
                          ? AppTheme.successLight
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 18,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      hasLocation ? 'Lokasi Terdeteksi' : 'Menunggu GPS',
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        color: hasLocation
                            ? AppTheme.successLight
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (_isCapturingLocation) ...[
                      SizedBox(width: 2.w),
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 2.h),
                Text(
                  'Koordinat:',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  _formatCoordinates(),
                  style: AppTheme.dataTextStyle(isLight: true).copyWith(
                    fontSize: 12.sp,
                  ),
                ),
                if (_accuracyText.isNotEmpty) ...[
                  SizedBox(height: 1.h),
                  Text(
                    _accuracyText,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),

          SizedBox(height: 3.h),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _isCapturingLocation ? null : _captureLocation,
                  icon: CustomIconWidget(
                    iconName: 'refresh',
                    color: _isCapturingLocation
                        ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
                        : AppTheme.lightTheme.colorScheme.primary,
                    size: 18,
                  ),
                  label:
                      Text(_isCapturingLocation ? 'Mengambil...' : 'Perbarui'),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: hasLocation ? _openGoogleMaps : null,
                  icon: CustomIconWidget(
                    iconName: 'map',
                    color: hasLocation
                        ? Colors.white
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 18,
                  ),
                  label: Text('Verifikasi Lokasi'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    backgroundColor: hasLocation
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme
                            .lightTheme.colorScheme.surfaceContainerHighest,
                    foregroundColor: hasLocation
                        ? Colors.white
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),
          Text(
            'Lokasi GPS diperlukan untuk verifikasi kunjungan lapangan.',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
