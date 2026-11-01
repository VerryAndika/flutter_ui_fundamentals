import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/identity_header.dart';
import 'course_detail_screen.dart';
import '../widgets/course_card.dart';
import '../providers/course_provider.dart';

// P6 Tahap 11-12: screen (folder screens/) hanya membaca state provider (initial/loading/error/success).
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
      // Tahap 14: 1 kolom (compact), 2 (medium), 3 (expanded).
      CourseLoadStatus.success => LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final columns = w < 600 ? 1 : (w < 840 ? 2 : 3);
          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              mainAxisExtent: 88,
              crossAxisSpacing: 8,
              mainAxisSpacing: 4,
            ),
            itemCount: provider.courses.length,
            itemBuilder: (context, i) {
              final course = provider.courses[i];
              return CourseCard(
                course: course,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CourseDetailScreen(course: course),
                  ),
                ),
              );
            },
          );
        },
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
