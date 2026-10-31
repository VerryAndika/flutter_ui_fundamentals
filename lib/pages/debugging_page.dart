import 'package:flutter/material.dart';

import '../identity.dart';

// Tahap 15 Kasus A (sebelum): kode dari worksheet yang sengaja dibiarkan
// overflow agar error-nya bisa diamati pada mode debug.
class OverflowDemoPage extends StatelessWidget {
  const OverflowDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kasus A - Sebelum')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.info),
            SizedBox(width: 8),
            Text(
              '$studentId - $studentName - Ini adalah teks yang sangat panjang untuk menguji layout',
            ),
          ],
        ),
      ),
    );
  }
}

// Tahap 15 Kasus A (sesudah): RenderFlex overflow diperbaiki dengan Expanded.
class DebuggingPage extends StatelessWidget {
  const DebuggingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Debugging Challenge')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kasus A - sebelum: lihat /tahap15-overflow. Text di dalam Row '
              'mendapat lebar tak terbatas, sehingga teks panjang melebihi '
              'layar dan muncul garis kuning-hitam.',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 16),
            Text('Kasus A - sesudah (diperbaiki dengan Expanded):'),
            SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '$studentId - $studentName - Ini adalah teks yang sangat '
                    'panjang untuk menguji layout',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
