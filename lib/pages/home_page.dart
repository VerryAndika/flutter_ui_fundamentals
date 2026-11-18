import 'package:flutter/material.dart';

import '../identity.dart';
import '../services/auth_service.dart';
import 'login_page.dart';

// P9 Praktik 2: Home + tombol Logout (session dihapus -> kembali ke Login).
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _logout(BuildContext context) async {
    await AuthService.instance.logout(); // Session Removed
    if (!context.mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('KosFinder'),
        actions: [
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.verified_user, size: 56, color: Colors.green),
            const SizedBox(height: 12),
            Text('Login sebagai: ${user?.email ?? '-'}'),
            const SizedBox(height: 4),
            const Text('P9 • $studentId - $studentName'),
          ],
        ),
      ),
    );
  }
}
