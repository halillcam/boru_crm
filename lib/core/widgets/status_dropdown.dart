import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../utils/status_helper.dart';

class StatusDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const StatusDropdown({super.key, required this.value, required this.onChanged});

  static const _statuses = ['new', 'contacted', 'negotiating', 'won', 'lost'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.unfold_more, color: AppColors.textSecondary, size: 20),
          items: _statuses.map((status) {
            return DropdownMenuItem(
              value: status,
              child: Row(
                children: [
                  Icon(Icons.swap_vert, size: 16, color: StatusHelper.colorFor(status)),
                  const SizedBox(width: 8),
                  Text(StatusHelper.labelFor(status), style: AppTextStyles.cardTitle),
                ],
              ),
            );
          }).toList(),
          onChanged: (newValue) {
            if (newValue != null) onChanged(newValue);
          },
        ),
      ),
    );
  }
}
