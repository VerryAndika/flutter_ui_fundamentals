import 'package:flutter/material.dart';

import '../../identity.dart';

const List<String> skills = [
  'Dart',
  'Flutter',
  'Git',
  'Figma',
  'REST API',
  'Firebase',
  'SQL',
];

Widget buildBox(String label, Color color) {
  return Container(
    height: 80,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
  );
}

// Tahap 4: Expanded (flex), Flexible, dan Wrap.
class FlexibleWrapPage extends StatelessWidget {
  const FlexibleWrapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('P5 Tahap 4 - Expanded & Wrap')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '$studentId - $studentName',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('Expanded flex 2 : 1'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(flex: 2, child: buildBox('A (flex 2)', Colors.indigo.shade100)),
                const SizedBox(width: 8),
                Expanded(child: buildBox('B (flex 1)', Colors.teal.shade100)),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Flexible: boleh lebih kecil dari sisa ruang'),
            const SizedBox(height: 8),
            Row(
              children: [
                Flexible(
                  child: SizedBox(
                    width: 120,
                    child: buildBox('Flexible', Colors.amber.shade100),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(child: buildBox('Expanded', Colors.teal.shade100)),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Wrap: chip pindah ke baris berikutnya'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: skills.map((e) => Chip(label: Text(e))).toList(),
            ),
            const SizedBox(height: 16),
            const Text('Row biasa: chip tidak cukup ruang (overflow)'),
            const SizedBox(height: 8),
            Row(children: skills.map((e) => Chip(label: Text(e))).toList()),
          ],
        ),
      ),
    );
  }
}
