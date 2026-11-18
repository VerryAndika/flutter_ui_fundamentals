import 'package:supabase_flutter/supabase_flutter.dart';

// P9 Praktik 1: Authentication dengan Supabase Auth (email + password).
// Hanya memakai publishable/anon key; service_role key tidak pernah di app.
class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  SupabaseClient get _client => Supabase.instance.client;

  User? get currentUser => _client.auth.currentUser;
  Session? get currentSession => _client.auth.currentSession;
  bool get isLoggedIn => currentSession != null;

  // P9 Praktik 3: name & role dikirim sebagai user metadata, lalu dibaca
  // trigger handle_new_user untuk membuat baris di tabel profiles.
  // Role admin tidak bisa dipilih dari aplikasi.
  Future<AuthResponse> register({
    required String email,
    required String password,
    String name = '',
    String role = 'seeker', // 'seeker' atau 'owner'
  }) {
    return _client.auth.signUp(
      email: email,
      password: password,
      data: {'name': name, 'role': role},
    );
  }

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) {
    return _client.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> logout() => _client.auth.signOut();
}

/// Pesan error Supabase Auth dalam Bahasa Indonesia.
String authErrorMessage(Object e) {
  if (e is AuthException) {
    final m = e.message.toLowerCase();
    if (m.contains('invalid login credentials')) {
      return 'Email atau password salah.';
    }
    if (m.contains('already registered') || m.contains('already exists')) {
      return 'Email sudah terdaftar. Silakan login.';
    }
    if (m.contains('email not confirmed')) {
      return 'Email belum dikonfirmasi.';
    }
    if (m.contains('password')) {
      return 'Password tidak memenuhi syarat: ${e.message}';
    }
    return e.message;
  }
  return 'Terjadi kesalahan. Periksa koneksi internet Anda.';
}
