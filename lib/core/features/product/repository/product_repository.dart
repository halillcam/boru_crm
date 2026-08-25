import 'package:boru_crm/core/supabase_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../product_model.dart';

class ProductRepository {
  final SupabaseClient _client = SupabaseClientProvider.supabase;

  Future<List<ProductModel>> fetchProducts() async {
    final response = await _client.from('products').select().order('created_at', ascending: false);

    return (response as List).map((json) => ProductModel.fromJson(json)).toList();
  }

  Future<ProductModel> addProduct(ProductModel product) async {
    final response = await _client
        .from('products')
        .insert(product.toInsertJson())
        .select()
        .single();

    return ProductModel.fromJson(response);
  }

  Future<void> deleteProduct(String id) async {
    await _client.from('products').delete().eq('id', id);
  }
}
