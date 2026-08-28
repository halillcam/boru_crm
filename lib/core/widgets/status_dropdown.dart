import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../utils/status_helper.dart';

class StatusDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const StatusDropdown({super.key, required this.value, required this.onChanged});

  // Kod (value) hep İngilizce kalmalı — veritabanı ve StatusHelper bunu bekliyor
  static const _statuses = ['paid', 'unpaid', 'pending'];

  @override
  Widget build(BuildContext context) {
    // Eski/bozuk veriye karşı güvenlik: listede yoksa ilk değere düş
    final safeValue = _statuses.contains(value) ? value : _statuses.last;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: safeValue,
          isExpanded: true,
          icon: const Icon(Icons.unfold_more, color: AppColors.textSecondary, size: 20),
          items: _statuses.map((status) {
            return DropdownMenuItem(
              value: status,
              child: Row(
                children: [
                  Icon(Icons.circle, size: 10, color: StatusHelper.colorFor(status)),
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
