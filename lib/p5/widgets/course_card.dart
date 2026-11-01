import 'package:flutter/material.dart';

// Kartu course yang dipakai di list dan grid.
class CourseCard extends StatelessWidget {
  const CourseCard({super.key, required this.course});

  final Map<String, dynamic> course;

  @override
  Widget build(BuildContext context) {
    final status = course['status'] as String? ?? 'planned';
    final (IconData icon, Color color, String label) = switch (status) {
      'done' => (Icons.check_circle, Colors.green, 'Selesai'),
      'active' => (Icons.play_circle, Colors.orange, 'Berjalan'),
      _ => (Icons.schedule, Colors.grey, 'Rencana'),
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    course['title'] as String,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('${course['code']} • ${course['credits']} SKS'),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(color: color)),
          ],
        ),
      ),
    );
  }
}
