import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SecurityOptionsWidget extends StatefulWidget {
  final Function(bool enabled) onPasswordProtection;
  final VoidCallback onAuditTrail;

  const SecurityOptionsWidget({
    Key? key,
    required this.onPasswordProtection,
    required this.onAuditTrail,
  }) : super(key: key);

  @override
  State<SecurityOptionsWidget> createState() => _SecurityOptionsWidgetState();
}

class _SecurityOptionsWidgetState extends State<SecurityOptionsWidget> {
  bool _passwordProtectionEnabled = false;
  bool _auditTrailEnabled = true;
  bool _encryptionEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppTheme.elevationLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'security',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 5.w,
                ),
                SizedBox(width: 2.w),
                Text(
                  "Keamanan & Audit",
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            SizedBox(height: 1.h),

            Text(
              "Proteksi dan pelacakan akses data",
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.7),
              ),
            ),

            SizedBox(height: 3.h),

            // Password Protection Option
            _buildSecurityOption(
              icon: 'lock',
              title: 'Proteksi Password',
              subtitle: 'Lindungi file ekspor dengan password',
              value: _passwordProtectionEnabled,
              onChanged: (value) {
                setState(() => _passwordProtectionEnabled = value);
                widget.onPasswordProtection(value);
              },
            ),

            SizedBox(height: 2.h),

            // Audit Trail Option
            _buildSecurityOption(
              icon: 'history',
              title: 'Audit Trail',
              subtitle: 'Lacak semua akses dan ekspor data',
              value: _auditTrailEnabled,
              onChanged: (value) {
                setState(() => _auditTrailEnabled = value);
              },
            ),

            SizedBox(height: 2.h),

            // Encryption Option
            _buildSecurityOption(
              icon: 'enhanced_encryption',
              title: 'Enkripsi File',
              subtitle: 'Enkripsi file dengan standar AES-256',
              value: _encryptionEnabled,
              onChanged: (value) {
                setState(() => _encryptionEnabled = value);
              },
            ),

            SizedBox(height: 3.h),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: widget.onAuditTrail,
                    icon: CustomIconWidget(
                      iconName: 'visibility',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 4.w,
                    ),
                    label: Text("Lihat Audit Log"),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _showSecuritySettings,
                    icon: CustomIconWidget(
                      iconName: 'settings',
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      size: 4.w,
                    ),
                    label: Text("Pengaturan"),
                  ),
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // Security Info
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'info',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 4.w,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      "Semua ekspor data mengikuti standar keamanan dan privasi yang berlaku.",
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityOption({
    required String icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        border: Border.all(
          color: AppTheme.lightTheme.dividerColor,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: value
                  ? AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1)
                  : AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            ),
            child: CustomIconWidget(
              iconName: icon,
              color: value
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.5),
              size: 4.w,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  subtitle,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.lightTheme.colorScheme.primary,
          ),
        ],
      ),
    );
  }

  void _showSecuritySettings() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppTheme.radiusLarge),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            children: [
              Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 2.h),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Pengaturan Keamanan",
                        style:
                            AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        "Konfigurasi tingkat keamanan untuk ekspor data",
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.7),
                        ),
                      ),
                      SizedBox(height: 3.h),

                      // Password Settings
                      _buildSettingSection(
                        "Pengaturan Password",
                        [
                          _buildSettingItem("Panjang Minimum", "8 karakter"),
                          _buildSettingItem(
                              "Kompleksitas", "Tinggi (A-z, 0-9, Simbol)"),
                          _buildSettingItem("Expired", "90 hari"),
                        ],
                      ),

                      SizedBox(height: 3.h),

                      // Audit Settings
                      _buildSettingSection(
                        "Pengaturan Audit",
                        [
                          _buildSettingItem("Retensi Log", "365 hari"),
                          _buildSettingItem("Detail Level", "Lengkap"),
                          _buildSettingItem("Notifikasi", "Real-time"),
                        ],
                      ),

                      SizedBox(height: 3.h),

                      // Encryption Settings
                      _buildSettingSection(
                        "Pengaturan Enkripsi",
                        [
                          _buildSettingItem("Algoritma", "AES-256"),
                          _buildSettingItem("Key Management", "HSM"),
                          _buildSettingItem("Sertifikat", "Valid s/d 2025"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        ...items,
      ],
    );
  }

  Widget _buildSettingItem(String label, String value) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
