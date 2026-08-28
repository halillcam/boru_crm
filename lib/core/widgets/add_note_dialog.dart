import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../constants/app_text_styles.dart';

class AddNoteDialog extends StatefulWidget {
  final Function(String content) onSave;

  const AddNoteDialog({super.key, required this.onSave});

  @override
  State<AddNoteDialog> createState() => _AddNoteDialogState();
}

class _AddNoteDialogState extends State<AddNoteDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSavePressed() {
    final content = _controller.text.trim();
    if (content.isEmpty) return;

    widget.onSave(content);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.cardBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(AppStrings.addNoteTitle, style: AppTextStyles.cardTitle),
      content: TextField(
        controller: _controller,
        maxLines: 4,
        autofocus: true,
        decoration: InputDecoration(
          hintText: AppStrings.addNoteHint,
          filled: true,
          fillColor: AppColors.background,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(AppStrings.cancel, style: AppTextStyles.subtitle),
        ),
        TextButton(
          onPressed: _onSavePressed,
          child: Text(AppStrings.save, style: AppTextStyles.linkText),
        ),
      ],
    );
  }
}
