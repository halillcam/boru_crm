import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../constants/app_text_styles.dart';
import '../features/customers/customer_model.dart';
import 'status_badge.dart';

class CustomerListTile extends StatelessWidget {
  final CustomerModel customer;
  final VoidCallback onTap;

  const CustomerListTile({super.key, required this.customer, required this.onTap});

  String get _initials {
    final parts = customer.name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return customer.name.isNotEmpty ? customer.name[0].toUpperCase() : '?';
  }

  String get _productLabel {
    if (customer.productNames.isEmpty) return AppStrings.noProduct;
    if (customer.productNames.length == 1) return customer.productNames.first;
    return '${customer.productNames.first} +${customer.productNames.length - 1}';
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: AppColors.avatarBackground,
              child: Text(
                _initials,
                style: const TextStyle(color: AppColors.avatarText, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(customer.name, style: AppTextStyles.cardTitle),
                  const SizedBox(height: 3),
                  if (customer.phone != null)
                    Text(customer.phone!, style: AppTextStyles.cardSubtitle),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(
                        Icons.inventory_2_outlined,
                        size: 13,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(_productLabel, style: AppTextStyles.cardSubtitle),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            StatusBadge(status: customer.status),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
