import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/course_provider.dart';
import '../widgets/course_card.dart';
import '../widgets/error_view.dart';
import '../widgets/identity_header.dart';
import 'course_detail_screen.dart';
import 'course_form_screen.dart';

// P6 Tahap 11-12: screen hanya membaca state provider.
// P7 Tahap 5: state eksplisit loading / error (+retry) / empty / success,
// dan tarik ke bawah (RefreshIndicator) untuk memuat ulang dari API.
class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();

    Widget content;
    if (provider.isLoading) {
      content = const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 12),
            Text('Memuat course dari server...'),
          ],
        ),
      );
    } else if (provider.error != null) {
      content = ErrorView(
        message: provider.error!,
        onRetry: context.read<CourseProvider>().loadCourses,
      );
    } else if (provider.courses.isEmpty) {
      content = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.inbox_outlined, size: 48),
            const SizedBox(height: 8),
            const Text('Data course belum tersedia'),
            TextButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Muat ulang'),
              onPressed: context.read<CourseProvider>().loadCourses,
            ),
          ],
        ),
      );
    } else {
      // P6 Tahap 14: 1 kolom (compact), 2 (medium), 3 (expanded).
      content = RefreshIndicator(
        onRefresh: context.read<CourseProvider>().loadCourses,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final columns = w < 600 ? 1 : (w < 840 ? 2 : 3);
            return GridView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
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
      );
    }

    return Stack(
      children: [
        Column(
          children: [
            IdentityHeader(
              subtitle:
                  '${provider.courses.length} course • '
                  '${provider.favoriteCount} favorite',
            ),
            Expanded(child: content),
          ],
        ),
        // P7 Tahap 6: buka form Create Course.
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton.extended(
            heroTag: 'add-course',
            icon: const Icon(Icons.add),
            label: const Text('Tambah'),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CourseFormScreen()),
            ),
          ),
        ),
      ],
    );
  }
}
