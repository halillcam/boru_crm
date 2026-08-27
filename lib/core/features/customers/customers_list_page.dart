import 'package:boru_crm/core/features/customers/add_edit_customer_page.dart';
import 'package:boru_crm/core/features/customers/customer_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../widgets/customer_list_tile.dart';
import 'customers_cubit.dart';
import 'customers_state.dart';

class CustomersListPage extends StatefulWidget {
  const CustomersListPage({super.key});

  @override
  State<CustomersListPage> createState() => _CustomersListPageState();
}

class _CustomersListPageState extends State<CustomersListPage> {
  @override
  void initState() {
    super.initState();
    context.read<CustomersCubit>().loadCustomers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          AppStrings.customersTitle,
          style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.textPrimary),
            onPressed: () {
              // TODO: arama özelliği ileride eklenecek
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const AddEditCustomerPage()));
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: BlocBuilder<CustomersCubit, CustomersState>(
        builder: (context, state) {
          return switch (state) {
            CustomersInitial() ||
            CustomersLoading() => const Center(child: CircularProgressIndicator()),
            CustomersError(:final message) => Center(child: Text('Hata: $message')),
            CustomersLoaded(:final customers) when customers.isEmpty => const Center(
              child: Text(AppStrings.noCustomersYet),
            ),
            CustomersLoaded(:final customers) => ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
              itemCount: customers.length,
              itemBuilder: (context, index) {
                final customer = customers[index];
                return CustomerListTile(
                  customer: customer,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => CustomerDetailPage(customer: customer)),
                    );
                  },
                );
              },
            ),
          };
        },
      ),
    );
  }
}
