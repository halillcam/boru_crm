import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../constants/app_text_styles.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/date_picker_field.dart';
import '../../widgets/paid_toggle.dart';
import '../../widgets/primary_button.dart';
import '../product/product_cubit.dart';
import '../product/product_state.dart';
import '../product/product_model.dart';
import 'purchase_cubit.dart';

class AddPurchasePage extends StatefulWidget {
  final String customerId;

  const AddPurchasePage({super.key, required this.customerId});

  @override
  State<AddPurchasePage> createState() => _AddPurchasePageState();
}

class _AddPurchasePageState extends State<AddPurchasePage> {
  final _amountController = TextEditingController();
  ProductModel? _selectedProduct;
  DateTime? _selectedDate;
  bool _isPaid = false;

  @override
  void initState() {
    super.initState();
    context.read<ProductCubit>().loadProducts();
    _selectedDate = DateTime.now();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _onProductSelected(ProductModel product) {
    setState(() {
      _selectedProduct = product;
      _amountController.text = product.price.toStringAsFixed(0);
    });
  }

  void _onSavePressed() {
    if (_selectedProduct == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text(AppStrings.productRequired)));
      return;
    }

    final amount = double.tryParse(_amountController.text.trim()) ?? 0;

    context.read<PurchaseCubit>().addPurchase(
      customerId: widget.customerId,
      productId: _selectedProduct!.id,
      amount: amount,
      purchasedAt: _selectedDate ?? DateTime.now(), // <-- eklendi
      isPaid: _isPaid,
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          AppStrings.addPurchaseTitle,
          style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppStrings.productLabel, style: AppTextStyles.label),
              const SizedBox(height: 6),
              BlocBuilder<ProductCubit, ProductState>(
                builder: (context, state) {
                  if (state is! ProductLoaded) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<ProductModel>(
                        value: _selectedProduct,
                        isExpanded: true,
                        hint: const Text(AppStrings.selectProductHint),
                        icon: const Icon(
                          Icons.unfold_more,
                          color: AppColors.textSecondary,
                          size: 20,
                        ),
                        items: state.products.map((product) {
                          return DropdownMenuItem(
                            value: product,
                            child: Text(product.name, style: AppTextStyles.cardTitle),
                          );
                        }).toList(),
                        onChanged: (product) {
                          if (product != null) _onProductSelected(product);
                        },
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: AppStrings.amountLabel,
                hint: AppStrings.amountHint,
                icon: Icons.currency_lira, // <-- lira ikonu
                controller: _amountController,
              ),
              const SizedBox(height: 16),
              DatePickerField(
                label: AppStrings.purchaseDateLabel,
                selectedDate: _selectedDate,
                onDateSelected: (date) => setState(() => _selectedDate = date),
              ),
              const SizedBox(height: 16),
              PaidToggle(value: _isPaid, onChanged: (value) => setState(() => _isPaid = value)),
              const SizedBox(height: 24),
              PrimaryButton(text: AppStrings.savePurchase, onPressed: _onSavePressed),
            ],
          ),
        ),
      ),
    );
  }
}
