import 'package:boru_crm/core/features/product/add_product_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../widgets/product_list_tile.dart';
import 'product_cubit.dart';
import 'product_state.dart';

class ProductsListPage extends StatefulWidget {
  const ProductsListPage({super.key});

  @override
  State<ProductsListPage> createState() => _ProductsListPageState();
}

class _ProductsListPageState extends State<ProductsListPage> {
  @override
  void initState() {
    super.initState();
    context.read<ProductCubit>().loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          AppStrings.productsTitle,
          style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const AddProductPage()));
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          return switch (state) {
            ProductInitial() ||
            ProductLoading() => const Center(child: CircularProgressIndicator()),
            ProductError(:final message) => Center(child: Text('Hata: $message')),
            ProductLoaded(:final products) when products.isEmpty => const Center(
              child: Text(AppStrings.noProductsYet),
            ),
            ProductLoaded(:final products) => ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ProductListTile(
                  product: product,
                  onDelete: () {
                    context.read<ProductCubit>().deleteProduct(product.id);
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
