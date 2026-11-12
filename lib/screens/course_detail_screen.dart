import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';
import '../widgets/identity_header.dart';
import 'course_form_screen.dart';

// P6 Tahap 13: status favorite di detail dibaca dari provider yang sama
// dengan list dan FavoritesScreen.
// P7 Tahap 7: data course diambil ulang dari provider (berdasarkan code)
// agar hasil edit langsung terlihat; course dari constructor jadi fallback.
class CourseDetailScreen extends StatelessWidget {
  const CourseDetailScreen({super.key, required this.course});

  final Course course;

  // P7 Tahap 8: konfirmasi -> DELETE -> SnackBar -> kembali ke list.
  Future<void> _confirmDelete(BuildContext context, Course course) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus course?'),
        content: Text('${course.code} - ${course.title} akan dihapus.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    try {
      await context.read<CourseProvider>().deleteCourse(course);
      if (!context.mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text('Course ${course.code} dihapus')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!context.mounted) return;
      messenger.showSnackBar(
        SnackBar(
          backgroundColor: Colors.red.shade700,
          content: Text(e.toString().replaceFirst('Exception: ', '')),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final course =
        context.select<CourseProvider, Course?>(
          (p) => p.courseByCode(this.course.code),
        ) ??
        this.course;
    final favorite = context.select<CourseProvider, bool>(
      (p) => p.isFavorite(course.code),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(course.code),
        actions: [
          IconButton(
            tooltip: 'Edit',
            icon: const Icon(Icons.edit),
            onPressed: course.id == null
                ? null
                : () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CourseFormScreen(initial: course),
                    ),
                  ),
          ),
          IconButton(
            tooltip: 'Hapus',
            icon: const Icon(Icons.delete_outline),
            onPressed: course.id == null
                ? null
                : () => _confirmDelete(context, course),
          ),
        ],
      ),
      body: ListView(
        children: [
          const IdentityHeader(subtitle: 'Detail course'),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              course.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.school),
            title: const Text('SKS'),
            trailing: Text('${course.credits}'),
          ),
          ListTile(
            leading: const Icon(Icons.flag),
            title: const Text('Status'),
            trailing: Text(course.statusLabel),
          ),
          ListTile(
            leading: Icon(
              favorite ? Icons.favorite : Icons.favorite_border,
              color: favorite ? Colors.pink : null,
            ),
            title: const Text('Favorite'),
            trailing: Text(favorite ? 'Ya' : 'Tidak'),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: FilledButton.icon(
              icon: Icon(favorite ? Icons.heart_broken : Icons.favorite),
              label: Text(
                favorite ? 'Hapus dari favorite' : 'Tambah ke favorite',
              ),
              onPressed: () =>
                  context.read<CourseProvider>().toggleFavorite(course.code),
            ),
          ),
        ],
      ),
    );
  }
}
