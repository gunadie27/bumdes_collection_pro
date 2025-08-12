import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class NotificationSearchWidget extends StatefulWidget {
  final Function(String) onSearchChanged;
  final VoidCallback onSearchClosed;

  const NotificationSearchWidget({
    super.key,
    required this.onSearchChanged,
    required this.onSearchClosed,
  });

  @override
  State<NotificationSearchWidget> createState() =>
      _NotificationSearchWidgetState();
}

class _NotificationSearchWidgetState extends State<NotificationSearchWidget> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Auto-focus when widget appears
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.lightTheme.dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              focusNode: _focusNode,
              decoration: InputDecoration(
                hintText: "Cari notifikasi...",
                prefixIcon: Icon(
                  Icons.search,
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.6),
                  size: 5.w,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                          });
                          widget.onSearchChanged('');
                        },
                        icon: Icon(
                          Icons.clear,
                          size: 5.w,
                        ),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(
                    color: AppTheme.lightTheme.dividerColor,
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(
                    color: AppTheme.lightTheme.dividerColor,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    width: 2,
                  ),
                ),
                filled: true,
                fillColor: AppTheme.lightTheme.scaffoldBackgroundColor,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              ),
              onChanged: (value) {
                setState(() {});
                widget.onSearchChanged(value);
              },
              textInputAction: TextInputAction.search,
            ),
          ),
          SizedBox(width: 2.w),
          TextButton(
            onPressed: widget.onSearchClosed,
            child: Text(
              "Batal",
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
