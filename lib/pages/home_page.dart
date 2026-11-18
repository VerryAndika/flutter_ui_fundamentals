import 'package:flutter/material.dart';

import '../identity.dart';
import '../services/auth_service.dart';

// P9 Praktik 1: Home setelah login (versi awal).
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser;
    return Scaffold(
      appBar: AppBar(title: const Text('KosFinder')),
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
