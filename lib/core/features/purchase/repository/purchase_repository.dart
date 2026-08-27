import 'package:boru_crm/core/supabase_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../purchase_model.dart';

class PurchaseRepository {
  final SupabaseClient _client = SupabaseClientProvider.supabase;

  // Belirli bir müşterinin tüm satın alımlarını, ürün adıyla birlikte getirir
  Future<List<PurchaseModel>> fetchPurchasesForCustomer(String customerId) async {
    final response = await _client
        .from('purchases')
        .select('*, products(name)') // JOIN: products tablosundan sadece name'i al
        .eq('customer_id', customerId)
        .order('purchased_at', ascending: false);

    return (response as List).map((json) => PurchaseModel.fromJson(json)).toList();
  }

  Future<void> addPurchase({
    required String customerId,
    required String productId,
    required double amount,
    required DateTime purchasedAt, // <-- yeni parametre
    bool isPaid = false,
  }) async {
    await _client.from('purchases').insert({
      'customer_id': customerId,
      'product_id': productId,
      'amount': amount,
      'is_paid': isPaid,
      'purchased_at': purchasedAt.toIso8601String(), // <-- eklendi
    });
  }

  Future<void> markAsPaid(String purchaseId) async {
    await _client.from('purchases').update({'is_paid': true}).eq('id', purchaseId);
  }

  Future<void> deletePurchase(String id) async {
    await _client.from('purchases').delete().eq('id', id);
  }
}
