import 'package:boru_crm/core/features/customers/customer_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CustomerRepository {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<CustomerModel>> fetchCustomers() async {
    final response = await _client.from('customers').select().order('created_at', ascending: false);

    return (response as List).map((json) => CustomerModel.fromJson(json)).toList();
  }

  Future<CustomerModel> addCustomer(CustomerModel customer) async {
    final response = await _client
        .from('customers')
        .insert(customer.toInsertJson())
        .select()
        .single();

    return CustomerModel.fromJson(response);
  }

  Future<void> updateCustomer(String id, Map<String, dynamic> updates) async {
    await _client.from('customers').update(updates).eq('id', id);
  }

  Future<void> deleteCustomer(String id) async {
    await _client.from('customers').delete().eq('id', id);
  }
}
