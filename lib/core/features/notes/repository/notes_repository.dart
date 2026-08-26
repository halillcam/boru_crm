import 'package:boru_crm/core/features/notes/notes_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NoteRepository {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<NoteModel>> fetchNotesForCustomer(String customerId) async {
    final response = await _client
        .from('notes')
        .select()
        .eq('customer_id', customerId)
        .order('created_at', ascending: false);

    return (response as List).map((json) => NoteModel.fromJson(json)).toList();
  }

  Future<void> addNote(String customerId, String content) async {
    await _client.from('notes').insert({'customer_id': customerId, 'content': content});
  }

  Future<void> deleteNote(String id) async {
    await _client.from('notes').delete().eq('id', id);
  }
}
