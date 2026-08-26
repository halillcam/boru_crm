import 'package:flutter/material.dart';
import '../constants/app_text_styles.dart';
import '../utils/status_helper.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final color = StatusHelper.colorFor(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        StatusHelper.labelFor(status),
        style: AppTextStyles.badgeText.copyWith(color: color),
      ),
    );
  }
}
