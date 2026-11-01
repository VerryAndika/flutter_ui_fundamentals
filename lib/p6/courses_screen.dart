import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../p5/widgets/identity_header.dart';
import 'course_card.dart';
import 'course_provider.dart';

// Tahap 11: UI hanya membaca state provider (initial/loading/error/success).
class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();
    final Widget content = switch (provider.status) {
      CourseLoadStatus.initial => Center(
        child: FilledButton.icon(
          icon: const Icon(Icons.download),
          label: const Text('Muat course'),
          onPressed: () => context.read<CourseProvider>().loadCourses(),
        ),
      ),
      CourseLoadStatus.loading => const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 12),
            Text('Memuat course...'),
          ],
        ),
      ),
      CourseLoadStatus.error => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 8),
              Text(
                'Gagal memuat course:\n${provider.error}',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () => context.read<CourseProvider>().loadCourses(),
                child: const Text('Coba lagi'),
              ),
            ],
          ),
        ),
      ),
      CourseLoadStatus.success => ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: provider.courses.length,
        itemBuilder: (context, i) => CourseCard(course: provider.courses[i]),
      ),
    };
    return Column(
      children: [
        IdentityHeader(
          subtitle:
              '${provider.courses.length} course • '
              '${provider.favoriteCount} favorite',
        ),
        Expanded(child: content),
      ],
    );
  }
}
