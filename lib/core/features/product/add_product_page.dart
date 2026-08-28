import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';
import 'product_cubit.dart';
import 'product_model.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _onSavePressed() {
    final name = _nameController.text.trim();
    final price = double.tryParse(_priceController.text.trim()) ?? 0;

    if (name.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text(AppStrings.productNameRequired)));
      return;
    }

    final product = ProductModel(
      id: '',
      userId: '',
      name: name,
      price: price,
      createdAt: DateTime.now(),
    );

    context.read<ProductCubit>().addProduct(product);
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
          AppStrings.addProductTitle,
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
              CustomTextField(
                label: AppStrings.productNameLabel,
                hint: AppStrings.productNameHint,
                icon: Icons.inventory_2_outlined,
                controller: _nameController,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: AppStrings.priceLabel,
                hint: AppStrings.priceHint,
                icon: Icons.currency_lira, // <-- lira ikonu
                controller: _priceController,
              ),
              const SizedBox(height: 24),
              PrimaryButton(text: AppStrings.saveProduct, onPressed: _onSavePressed),
            ],
          ),
        ),
      ),
    );
  }
}
