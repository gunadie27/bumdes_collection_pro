import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class CollectionNotesWidget extends StatefulWidget {
  final Function(String) onNotesChanged;
  final String? initialNotes;

  const CollectionNotesWidget({
    Key? key,
    required this.onNotesChanged,
    this.initialNotes,
  }) : super(key: key);

  @override
  State<CollectionNotesWidget> createState() => _CollectionNotesWidgetState();
}

class _CollectionNotesWidgetState extends State<CollectionNotesWidget> {
  final TextEditingController _notesController = TextEditingController();
  final int _maxLength = 500;

  @override
  void initState() {
    super.initState();
    if (widget.initialNotes != null) {
      _notesController.text = widget.initialNotes!;
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _onNotesChanged(String value) {
    widget.onNotesChanged(value);
    setState(() {}); // Update character counter
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
                iconName: 'note_alt',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 3.w),
              Text(
                'Catatan Kunjungan',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Notes Text Area
          TextFormField(
            controller: _notesController,
            onChanged: _onNotesChanged,
            maxLines: 6,
            maxLength: _maxLength,
            textInputAction: TextInputAction.newline,
            style: AppTheme.lightTheme.textTheme.bodyMedium,
            decoration: InputDecoration(
              hintText:
                  'Tulis catatan kunjungan, kondisi anggota, kesepakatan pembayaran, atau informasi penting lainnya...',
              hintStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                    .withValues(alpha: 0.6),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                borderSide: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                borderSide: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  width: 2.0,
                ),
              ),
              contentPadding: EdgeInsets.all(4.w),
              counterText: '', // Hide default counter
            ),
          ),

          SizedBox(height: 2.h),

          // Character Counter and Tips
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Catatan membantu supervisor memahami kondisi lapangan',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              Text(
                '${_notesController.text.length}/$_maxLength',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: _notesController.text.length > _maxLength * 0.9
                      ? AppTheme.warningLight
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Quick Note Templates
          Text(
            'Template Cepat:',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: [
              _buildQuickNoteChip('Anggota kooperatif'),
              _buildQuickNoteChip('Kesulitan ekonomi'),
              _buildQuickNoteChip('Janji bayar minggu depan'),
              _buildQuickNoteChip('Tidak ada di tempat'),
              _buildQuickNoteChip('Meminta perpanjangan'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickNoteChip(String text) {
    return GestureDetector(
      onTap: () {
        final currentText = _notesController.text;
        final newText = currentText.isEmpty ? text : '$currentText\n$text';

        if (newText.length <= _maxLength) {
          _notesController.text = newText;
          _notesController.selection = TextSelection.fromPosition(
            TextPosition(offset: newText.length),
          );
          _onNotesChanged(newText);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.primaryContainer
              .withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Text(
          text,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
