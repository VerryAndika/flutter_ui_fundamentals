import 'package:flutter/material.dart';

import '../../identity.dart';
import '../breakpoints.dart';

// Tahap 3: LayoutBuilder memilih layout dari constraints parent.
class LayoutBuilderPage extends StatelessWidget {
  const LayoutBuilderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('P5 Tahap 3 - LayoutBuilder')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            return const CompactLayout();
          } else if (constraints.maxWidth < 840) {
            return const MediumLayout();
          } else {
            return const ExpandedLayout();
          }
        },
      ),
    );
  }
}

Widget _identity(String category, Color color) {
  return Card(
    color: color,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '$studentId - $studentName',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text('Layout: $category'),
        ],
      ),
    ),
  );
}

Widget _panel(String label, IconData icon) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [Icon(icon, size: 32), const SizedBox(height: 8), Text(label)],
      ),
    ),
  );
}

// Compact: satu kolom, panel disusun vertikal.
class CompactLayout extends StatelessWidget {
  const CompactLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _identity('Compact (< 600)', Colors.orange.shade100),
        _panel('Menu', Icons.menu),
        _panel('Konten', Icons.article),
      ],
    );
  }
}

// Medium: dua panel berdampingan.
class MediumLayout extends StatelessWidget {
  const MediumLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _identity('Medium (600-839)', Colors.blue.shade100),
          Row(
            children: [
              Expanded(child: _panel('Menu', Icons.menu)),
              Expanded(child: _panel('Konten', Icons.article)),
            ],
          ),
        ],
      ),
    );
  }
}

// Expanded: sidebar tetap di kiri dan konten di kanan.
class ExpandedLayout extends StatelessWidget {
  const ExpandedLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 240,
          color: Colors.green.shade50,
          padding: const EdgeInsets.all(16),
          child: _panel('Sidebar', Icons.view_sidebar),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _identity('Expanded (>= 840)', Colors.green.shade100),
                Row(
                  children: [
                    Expanded(child: _panel('Konten 1', Icons.article)),
                    Expanded(child: _panel('Konten 2', Icons.article)),
                    Expanded(child: _panel('Konten 3', Icons.article)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Dipakai untuk menampilkan kategori saat ini di halaman lain.
String windowSizeLabel(double width) => switch (windowSizeFor(width)) {
  WindowSize.compact => 'Compact',
  WindowSize.medium => 'Medium',
  WindowSize.expanded => 'Expanded',
};
