import 'package:flutter/material.dart';

import '../../identity.dart';

// Tahap 7: Navigator.push() dan Navigator.pop().
class NavHomePage extends StatelessWidget {
  const NavHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('P5 Tahap 7 - HomePage')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              studentName,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text(studentId),
            const SizedBox(height: 24),
            FilledButton.icon(
              icon: const Icon(Icons.open_in_new),
              label: const Text('Buka Detail'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DetailPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    // AppBar otomatis menampilkan tombol back karena ada route di bawahnya.
    return Scaffold(
      appBar: AppBar(title: const Text('DetailPage')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('$studentId - $studentName'),
            const SizedBox(height: 8),
            const Text('Halaman ini dibuka dengan Navigator.push()'),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              icon: const Icon(Icons.arrow_back),
              label: const Text('Kembali'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
