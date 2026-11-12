import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/course.dart';
import 'course_data_source.dart';

// P7 Tahap 12: sumber data dari tabel `courses` di Supabase.
// P7 Tahap 17: error backend diterjemahkan menjadi pesan yang informatif.
class CourseSupabaseService implements CourseDataSource {
  final supabase = Supabase.instance.client;

  // Kode error PostgreSQL/PostgREST yang umum pada praktikum.
  Exception _friendly(String action, Object e) {
    if (e is PostgrestException) {
      final reason = switch (e.code) {
        '23505' => 'code sudah dipakai (melanggar UNIQUE)',
        '23514' => 'data melanggar CHECK constraint (credits/status)',
        '42501' => 'ditolak policy RLS (permission denied)',
        'PGRST116' => 'data tidak ditemukan',
        _ => e.message,
      };
      return Exception('Gagal $action [${e.code}]: $reason');
    }
    final text = e.toString();
    if (text.contains('Failed to fetch') ||
        text.contains('SocketException') ||
        text.contains('ClientException')) {
      return Exception('Gagal $action: tidak ada koneksi ke server');
    }
    return Exception('Gagal $action: $text');
  }

  @override
  Future<List<Course>> getCourses() async {
    try {
      final data = await supabase.from('courses').select().order('id');

      return (data as List)
          .map((e) => Course.fromJson(e as Map<String, dynamic>))
          .toList();
    } on TypeError catch (e) {
      // Key/tipe JSON tidak cocok dengan model Course.
      throw Exception('Gagal membaca course: format data tidak sesuai ($e)');
    } catch (e) {
      throw _friendly('mengambil course', e);
    }
  }

  // P7 Tahap 13: INSERT lalu kembalikan row baru (sama seperti versi REST).
  @override
  Future<Course> createCourse(Course course) async {
    try {
      final row = await supabase
          .from('courses')
          .insert(course.toJson())
          .select()
          .single();

      return Course.fromJson(row);
    } catch (e) {
      throw _friendly('membuat course', e);
    }
  }

  // P7 Tahap 14: UPDATE berdasarkan id.
  // .select() dipakai agar terlihat jika tidak ada baris yang berubah
  // (id tidak ada atau diblokir RLS) — Supabase tidak menganggapnya error.
  @override
  Future<void> updateCourse(int id, Course course) async {
    List<dynamic> rows;
    try {
      rows = await supabase
          .from('courses')
          .update(course.toJson())
          .eq('id', id)
          .select();
    } catch (e) {
      throw _friendly('memperbarui course', e);
    }
    if (rows.isEmpty) {
      throw Exception(
        'Gagal memperbarui course: tidak ada baris yang berubah '
        '(id tidak ditemukan atau ditolak RLS)',
      );
    }
  }

  // P7 Tahap 15: DELETE berdasarkan id.
  @override
  Future<void> deleteCourse(int id) async {
    List<dynamic> rows;
    try {
      rows = await supabase.from('courses').delete().eq('id', id).select();
    } catch (e) {
      throw _friendly('menghapus course', e);
    }
    if (rows.isEmpty) {
      throw Exception(
        'Gagal menghapus course: tidak ada baris yang terhapus '
        '(id tidak ditemukan atau ditolak RLS)',
      );
    }
  }
}
