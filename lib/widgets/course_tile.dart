import 'package:flutter/material.dart';

// Tahap 14: item list materi dari JSON, status divisualkan secara conditional.
class CourseTile extends StatelessWidget {
  const CourseTile({super.key, required this.course});

  final Map<String, dynamic> course;

  @override
  Widget build(BuildContext context) {
    final status = course['status'] as String? ?? 'planned';
    final progress = (course['progress'] as num? ?? 0).toInt();
    final (IconData icon, Color color, String label) = switch (status) {
      'done' => (Icons.check_circle, Colors.green, 'Selesai'),
      'active' => (Icons.play_circle, Colors.orange, 'Berjalan'),
      _ => (Icons.schedule, Colors.grey, 'Rencana'),
    };

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: Icon(icon, color: color, size: 32),
        title: Text(course['title'] as String),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${course['code']} • ${course['credits']} SKS'),
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value: progress / 100,
              color: color,
              backgroundColor: color.withValues(alpha: 0.15),
            ),
          ],
        ),
        trailing: Text(
          '$label\n$progress%',
          textAlign: TextAlign.end,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
