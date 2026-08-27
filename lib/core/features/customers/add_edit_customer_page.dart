import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../constants/app_text_styles.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/status_dropdown.dart';
import 'customer_model.dart';
import 'customers_cubit.dart';

class AddEditCustomerPage extends StatefulWidget {
  final CustomerModel? customer; // null ise "ekleme" modu

  const AddEditCustomerPage({super.key, this.customer});

  @override
  State<AddEditCustomerPage> createState() => _AddEditCustomerPageState();
}

class _AddEditCustomerPageState extends State<AddEditCustomerPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late String _status;

  bool get _isEditMode => widget.customer != null;

  @override
  void initState() {
    super.initState();
    final customer = widget.customer;
    _nameController = TextEditingController(text: customer?.name ?? '');
    _phoneController = TextEditingController(text: customer?.phone ?? '');
    _emailController = TextEditingController(text: customer?.email ?? '');
    _status = customer?.status ?? 'new';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _onSavePressed() {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text(AppStrings.nameRequired)));
      return;
    }

    final cubit = context.read<CustomersCubit>();

    if (_isEditMode) {
      cubit.updateCustomer(widget.customer!.id, {
        'name': name,
        'phone': _phoneController.text.trim(),
        'email': _emailController.text.trim(),
        'status': _status,
      });
    } else {
      final newCustomer = CustomerModel(
        id: '', // Supabase üretecek
        userId: '', // Supabase üretecek (default auth.uid())
        name: name,
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        status: _status,
        createdAt: DateTime.now(), // kullanılmayacak, Supabase üretecek
        updatedAt: DateTime.now(),
      );
      cubit.addCustomer(newCustomer);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          _isEditMode ? AppStrings.editCustomerTitle : AppStrings.addCustomerTitle,
          style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
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
                label: AppStrings.nameLabel,
                hint: AppStrings.nameHint,
                icon: Icons.person_outline,
                controller: _nameController,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: AppStrings.phoneLabel,
                hint: AppStrings.phoneHint,
                icon: Icons.phone_outlined,
                controller: _phoneController,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: AppStrings.emailLabel,
                hint: AppStrings.emailHintCustomer,
                icon: Icons.email_outlined,
                controller: _emailController,
              ),
              const SizedBox(height: 16),
              Text(AppStrings.statusLabel, style: AppTextStyles.label),
              const SizedBox(height: 6),
              StatusDropdown(
                value: _status,
                onChanged: (newStatus) => setState(() => _status = newStatus),
              ),
              const SizedBox(height: 24),
              PrimaryButton(text: AppStrings.saveCustomer, onPressed: _onSavePressed),
            ],
          ),
        ),
      ),
    );
  }
}
