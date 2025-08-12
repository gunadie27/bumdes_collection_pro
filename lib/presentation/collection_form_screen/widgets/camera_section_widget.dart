import 'dart:io' if (dart.library.io) 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class CameraSectionWidget extends StatefulWidget {
  final Function(XFile?) onImageCaptured;
  final XFile? capturedImage;

  const CameraSectionWidget({
    Key? key,
    required this.onImageCaptured,
    this.capturedImage,
  }) : super(key: key);

  @override
  State<CameraSectionWidget> createState() => _CameraSectionWidgetState();
}

class _CameraSectionWidgetState extends State<CameraSectionWidget> {
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;
  bool _isInitializing = false;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<bool> _requestCameraPermission() async {
    if (kIsWeb) return true;

    final status = await Permission.camera.request();
    return status.isGranted;
  }

  Future<void> _initializeCamera() async {
    if (_isInitializing) return;

    setState(() {
      _isInitializing = true;
    });

    try {
      final hasPermission = await _requestCameraPermission();
      if (!hasPermission) {
        setState(() {
          _isInitializing = false;
        });
        return;
      }

      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        setState(() {
          _isInitializing = false;
        });
        return;
      }

      final camera = kIsWeb
          ? _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.front,
              orElse: () => _cameras.first)
          : _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.back,
              orElse: () => _cameras.first);

      _cameraController = CameraController(
          camera, kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high);

      await _cameraController!.initialize();
      await _applySettings();

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
          _isInitializing = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isInitializing = false;
        });
      }
    }
  }

  Future<void> _applySettings() async {
    if (_cameraController == null) return;

    try {
      await _cameraController!.setFocusMode(FocusMode.auto);
    } catch (e) {
      // Ignore focus mode errors
    }

    if (!kIsWeb) {
      try {
        await _cameraController!.setFlashMode(FlashMode.auto);
      } catch (e) {
        // Ignore flash mode errors on unsupported devices
      }
    }
  }

  Future<void> _capturePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      final XFile photo = await _cameraController!.takePicture();
      widget.onImageCaptured(photo);
    } catch (e) {
      // Handle capture error silently
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 1920,
          maxHeight: 1080,
          imageQuality: 85);

      if (image != null) {
        widget.onImageCaptured(image);
      }
    } catch (e) {
      // Handle gallery error silently
    }
  }

  void _retakePhoto() {
    widget.onImageCaptured(null);
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
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                width: 1)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            CustomIconWidget(
                iconName: 'camera_alt',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20),
            SizedBox(width: 3.w),
            Text('Foto Bukti Pembayaran',
                style: AppTheme.lightTheme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.w600)),
            Text(' *',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    color: AppTheme.errorLight, fontWeight: FontWeight.w600)),
          ]),
          SizedBox(height: 3.h),

          // Camera Preview or Captured Image
          Container(
              width: double.infinity,
              height: 40.h,
              decoration: BoxDecoration(
                  color:
                      AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.2),
                      width: 1)),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  child: widget.capturedImage != null
                      ? _buildCapturedImage()
                      : _buildCameraPreview())),

          SizedBox(height: 3.h),

          // Action Buttons
          if (widget.capturedImage != null)
            _buildRetakeButton()
          else
            _buildCaptureButtons(),

          SizedBox(height: 2.h),
          Text(
              'Ambil foto bukti pembayaran dengan jelas. Pastikan nominal dan tanggal terlihat.',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant)),
        ]));
  }

  Widget _buildCameraPreview() {
    if (_isInitializing) {
      return Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        CircularProgressIndicator(
            color: AppTheme.lightTheme.colorScheme.primary),
        SizedBox(height: 2.h),
        Text('Memuat kamera...',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant)),
      ]));
    }

    if (!_isCameraInitialized || _cameraController == null) {
      return Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        CustomIconWidget(
            iconName: 'camera_alt',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 48),
        SizedBox(height: 2.h),
        Text('Kamera tidak tersedia',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant)),
      ]));
    }

    return Stack(children: [
      SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: CameraPreview(_cameraController!)),
      // Camera overlay guide
      Center(
          child: Container(
              width: 70.w,
              height: 25.h,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.primary, width: 2),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall)),
              child: Center(
                  child: Text('Posisikan bukti pembayaran\ndi dalam frame ini',
                      textAlign: TextAlign.center,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                          backgroundColor:
                              Colors.black.withValues(alpha: 0.7)))))),
    ]);
  }

  Widget _buildCapturedImage() {
    return Stack(children: [
      SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: kIsWeb
              ? Image.network(widget.capturedImage!.path, fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                  return Center(
                      child: CustomIconWidget(
                          iconName: 'broken_image',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 48));
                })
              : Image.file(File(widget.capturedImage!.path), fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                  return Center(
                      child: CustomIconWidget(
                          iconName: 'broken_image',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 48));
                })),
      Positioned(
          top: 2.w,
          right: 2.w,
          child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                  color: AppTheme.successLight,
                  borderRadius: BorderRadius.circular(20)),
              child: CustomIconWidget(
                  iconName: 'check', color: Colors.white, size: 16))),
    ]);
  }

  Widget _buildCaptureButtons() {
    return Row(children: [
      Expanded(
          child: OutlinedButton.icon(
              onPressed: _pickFromGallery,
              icon: CustomIconWidget(
                  iconName: 'photo_library',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 18),
              label: Text('Galeri'),
              style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2.h)))),
      SizedBox(width: 3.w),
      Expanded(
          child: ElevatedButton.icon(
              onPressed: _isCameraInitialized ? _capturePhoto : null,
              icon: CustomIconWidget(
                  iconName: 'camera_alt', color: Colors.white, size: 18),
              label: Text('Ambil Foto'),
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2.h)))),
    ]);
  }

  Widget _buildRetakeButton() {
    return SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
            onPressed: _retakePhoto,
            icon: CustomIconWidget(
                iconName: 'refresh',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 18),
            label: Text('Ambil Ulang'),
            style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 2.h))));
  }
}
