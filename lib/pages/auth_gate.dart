import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import 'home_page.dart';
import 'login_page.dart';

// P9 Praktik 2: Check Session saat aplikasi dibuka.
// Supabase memulihkan session tersimpan di Supabase.initialize(), sehingga
// currentSession langsung bisa diperiksa:
//   Session Exists -> Home      No Session -> Login
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthService.instance.isLoggedIn
        ? const HomePage()
        : const LoginPage();
  }
}
