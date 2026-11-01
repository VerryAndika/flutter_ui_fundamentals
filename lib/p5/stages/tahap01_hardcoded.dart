import 'package:flutter/material.dart';

import '../../identity.dart';

// Tahap 1: membandingkan ukuran hard-coded dengan ukuran fleksibel.
class HardCodedWidthPage extends StatelessWidget {
  const HardCodedWidthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('P5 Tahap 1 - Hard-coded vs Flexible')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Sebelum: Container width: 500 di dalam Row'),
            const SizedBox(height: 8),
            // Lebar layar phone < 500, sehingga Row overflow.
            Row(
              children: [
                Container(
                  width: 500,
                  padding: const EdgeInsets.all(16),
                  color: Colors.red.shade100,
                  child: const Text('$studentId - $studentName'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Sesudah: width: double.infinity'),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Colors.green.shade100,
              child: const Text('$studentId - $studentName'),
            ),
            const SizedBox(height: 24),
            const Text('Sesudah: Expanded di dalam Row'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.green.shade100,
                    child: const Text('$studentId - $studentName'),
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
