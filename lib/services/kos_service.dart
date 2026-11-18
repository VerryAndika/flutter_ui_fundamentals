import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/kos.dart';

// P9 Praktik 5: CRUD tabel kos. Aturan akses ditegakkan RLS di database:
//   SELECT : semua user login        INSERT : owner/admin, owner_id = auth.uid()
//   UPDATE : hanya pemilik           DELETE : hanya pemilik
// Catatan: UPDATE/DELETE yang ditolak RLS tidak melempar error, melainkan
// tidak ada baris yang terpengaruh -> hasil select() diperiksa kosong/tidak.
class KosService {
  final SupabaseClient _client = Supabase.instance.client;

  String get currentUserId => _client.auth.currentUser!.id;

  Future<List<Kos>> fetchAll() async {
    final data = await _client
        .from('kos')
        .select()
        .order('created_at', ascending: false);
    return data.map(Kos.fromMap).toList();
  }

  Future<Kos?> fetchById(String id) async {
    final data = await _client.from('kos').select().eq('id', id).maybeSingle();
    return data == null ? null : Kos.fromMap(data);
  }

  Future<void> add({
    required String name,
    required String address,
    required int price,
  }) async {
    await _client.from('kos').insert({
      'owner_id': currentUserId,
      'name': name,
      'address': address,
      'price': price,
    });
  }

  /// true = berhasil, false = ditolak RLS / data tidak ditemukan
  Future<bool> update(String id, Map<String, dynamic> values) async {
    final rows = await _client.from('kos').update(values).eq('id', id).select();
    return rows.isNotEmpty;
  }

  /// true = berhasil, false = ditolak RLS / data tidak ditemukan
  Future<bool> delete(String id) async {
    final rows = await _client.from('kos').delete().eq('id', id).select();
    return rows.isNotEmpty;
  }
}

/// Pesan error database dalam Bahasa Indonesia.
String kosErrorMessage(Object e) {
  if (e is PostgrestException) {
    if (e.code == '42501') {
      return 'Ditolak oleh Row Level Security (42501): '
          'role Anda tidak boleh melakukan operasi ini.';
    }
    return 'Database error ${e.code}: ${e.message}';
  }
  return 'Terjadi kesalahan: $e';
}
