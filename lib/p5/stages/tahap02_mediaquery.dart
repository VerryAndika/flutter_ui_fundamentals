import 'package:flutter/material.dart';

import '../../identity.dart';

// Tahap 2: membaca ukuran dan orientasi layar dengan MediaQuery.
class MediaQueryPage extends StatelessWidget {
  const MediaQueryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;
    final bool compact = size.width < 600;

    return Scaffold(
      appBar: AppBar(title: const Text('P5 Tahap 2 - MediaQuery')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '$studentId - $studentName',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text('Width: ${size.width.toStringAsFixed(0)}'),
            Text('Height: ${size.height.toStringAsFixed(0)}'),
            Text('Orientation: $orientation'),
            const SizedBox(height: 16),
            Chip(
              avatar: Icon(compact ? Icons.phone_android : Icons.tablet),
              label: Text(compact ? 'Compact' : 'Wide'),
              backgroundColor: compact
                  ? Colors.orange.shade100
                  : Colors.blue.shade100,
            ),
          ],
        ),
      ),
    );
  }
}
