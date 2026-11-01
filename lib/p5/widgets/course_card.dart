import 'package:flutter/material.dart';

// Kartu course yang dipakai di list dan grid.
// Tahap 12: InkWell untuk tap/long press dan tombol favorite.
class CourseCard extends StatelessWidget {
  const CourseCard({
    super.key,
    required this.course,
    this.favorite = false,
    this.onTap,
    this.onLongPress,
    this.onFavoriteChanged,
  });

  final Map<String, dynamic> course;
  final bool favorite;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final ValueChanged<bool>? onFavoriteChanged;

  @override
  Widget build(BuildContext context) {
    final status = course['status'] as String? ?? 'planned';
    final (IconData icon, Color color, String label) = switch (status) {
      'done' => (Icons.check_circle, Colors.green, 'Selesai'),
      'active' => (Icons.play_circle, Colors.orange, 'Berjalan'),
      _ => (Icons.schedule, Colors.grey, 'Rencana'),
    };

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 8, 16),
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
                  if (onFavoriteChanged != null)
                    IconButton(
                      tooltip: favorite ? 'Hapus favorite' : 'Jadikan favorite',
                      icon: Icon(
                        favorite ? Icons.favorite : Icons.favorite_border,
                        color: favorite ? Colors.pink : null,
                      ),
                      onPressed: () => onFavoriteChanged!(!favorite),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text('${course['code']} • ${course['credits']} SKS'),
              const SizedBox(height: 4),
              Text(label, style: TextStyle(color: color)),
            ],
          ),
        ),
      ),
    );
  }
}
