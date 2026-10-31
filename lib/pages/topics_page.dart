import 'package:flutter/material.dart';

import '../identity.dart';

// Tahap 10: collection Dart.
final List<Map<String, dynamic>> topics = [
  {'title': 'Git & GitHub', 'subtitle': 'Version control', 'done': true},
  {'title': 'Dart Fundamentals', 'subtitle': 'Language basics', 'done': true},
  {
    'title': 'Flutter UI Fundamentals',
    'subtitle': 'Widgets & layout',
    'done': false,
  },
  {
    'title': '$studentId - $studentName',
    'subtitle': 'Pemilik aplikasi',
    'done': false,
  },
];

// Tahap 10: ListView.builder sederhana dengan Column + Expanded.
class Tahap10Page extends StatelessWidget {
  const Tahap10Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Collection List')),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(12),
            child: Text('$studentId - $studentName'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: topics.length,
              itemBuilder: (context, index) {
                final item = topics[index];
                return ListTile(
                  leading: Icon(
                    item['done'] == true
                        ? Icons.check_circle
                        : Icons.circle_outlined,
                  ),
                  title: Text(item['title'] as String),
                  subtitle: Text(item['subtitle'] as String),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Tahap 11: ListView.separated + Card + ringkasan collection.
class TopicsPage extends StatelessWidget {
  const TopicsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final int completed = topics.where((item) => item['done'] == true).length;

    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Topik')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                const Text(
                  '$studentId - $studentName',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('$completed dari ${topics.length} topik selesai'),
              ],
            ),
          ),
          // Expanded memberi ListView tinggi yang terbatas di dalam Column.
          Expanded(
            child: ListView.separated(
              itemCount: topics.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final item = topics[index];
                final bool done = item['done'] == true;
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: Icon(
                      done ? Icons.check_circle : Icons.schedule,
                      color: done ? Colors.green : Colors.orange,
                    ),
                    title: Text(item['title'] as String),
                    subtitle: Text(item['subtitle'] as String),
                    trailing: Text(done ? 'Selesai' : 'Belum'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
