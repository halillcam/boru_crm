import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../constants/app_text_styles.dart';

class PaidToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const PaidToggle({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(AppStrings.markAsPaid, style: AppTextStyles.cardTitle),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.primary, // <-- yeni
          ),
        ],
      ),
    );
  }
}
