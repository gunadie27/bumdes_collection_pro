import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class MemberInfoCard extends StatelessWidget {
  final Map<String, dynamic> memberData;

  const MemberInfoCard({
    super.key,
    required this.memberData,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppTheme.elevationLow,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Member Photo
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                color: AppTheme.lightTheme.colorScheme.surface,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                child: memberData["photo"] != null
                    ? CustomImageWidget(
                        imageUrl: memberData["photo"] as String,
                        width: 20.w,
                        height: 20.w,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        color: AppTheme.lightTheme.colorScheme.primaryContainer,
                        child: Center(
                          child: CustomIconWidget(
                            iconName: 'person',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 8.w,
                          ),
                        ),
                      ),
              ),
            ),
            SizedBox(width: 4.w),
            // Member Information
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    memberData["name"] as String? ?? "Nama Tidak Tersedia",
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'badge',
                        color: AppTheme.lightTheme.colorScheme.secondary,
                        size: 4.w,
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Text(
                          "ID: ${memberData["memberId"] as String? ?? "N/A"}",
                          style: AppTheme.lightTheme.textTheme.bodySmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 0.5.h),
                  GestureDetector(
                    onTap: () => _showContactOptions(context),
                    onLongPress: () => _showContactContextMenu(context),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'phone',
                          color: AppTheme.lightTheme.colorScheme.secondary,
                          size: 4.w,
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            memberData["phone"] as String? ?? "Tidak ada nomor",
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              decoration: TextDecoration.underline,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'location_on',
                        color: AppTheme.lightTheme.colorScheme.secondary,
                        size: 4.w,
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Text(
                          memberData["address"] as String? ??
                              "Alamat tidak tersedia",
                          style: AppTheme.lightTheme.textTheme.bodySmall,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showContactOptions(BuildContext context) {
    final phoneNumber = memberData["phone"] as String?;
    if (phoneNumber == null || phoneNumber.isEmpty) return;

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppTheme.radiusLarge),
        ),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
            Text(
              "Hubungi Member",
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'phone',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              title: Text("Telepon"),
              subtitle: Text(phoneNumber),
              onTap: () {
                Navigator.pop(context);
                // Implement phone call functionality
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'message',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              title: Text("SMS"),
              subtitle: Text("Kirim pesan singkat"),
              onTap: () {
                Navigator.pop(context);
                // Implement SMS functionality
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _showContactContextMenu(BuildContext context) {
    final phoneNumber = memberData["phone"] as String?;
    if (phoneNumber == null || phoneNumber.isEmpty) return;

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppTheme.radiusLarge),
        ),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
            Text(
              "Opsi Kontak",
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'content_copy',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              title: Text("Salin Nomor"),
              onTap: () {
                Navigator.pop(context);
                // Implement copy to clipboard
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'map',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              title: Text("Lihat di Peta"),
              onTap: () {
                Navigator.pop(context);
                // Implement map view
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
