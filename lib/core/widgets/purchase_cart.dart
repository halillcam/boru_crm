import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../constants/app_text_styles.dart';
import '../features/purchase/purchase_model.dart';

class PurchaseCard extends StatelessWidget {
  final PurchaseModel purchase;

  const PurchaseCard({super.key, required this.purchase});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(purchase.productName, style: AppTextStyles.cardTitle),
                const SizedBox(height: 4),
                Text(
                  '${purchase.purchasedAt.day}.${purchase.purchasedAt.month}.${purchase.purchasedAt.year}',
                  style: AppTextStyles.cardSubtitle,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('\$${purchase.amount.toStringAsFixed(0)}', style: AppTextStyles.cardTitle),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: purchase.isPaid ? AppColors.paidBackground : AppColors.unpaidBackground,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  purchase.isPaid ? AppStrings.paid : AppStrings.unpaid,
                  style: AppTextStyles.badgeText.copyWith(
                    color: purchase.isPaid ? AppColors.paidText : AppColors.unpaidText,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
