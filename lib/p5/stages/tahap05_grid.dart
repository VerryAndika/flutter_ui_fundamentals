import 'package:flutter/material.dart';

import '../breakpoints.dart';
import '../course_data.dart';
import '../widgets/course_card.dart';
import '../widgets/identity_header.dart';

// Tahap 5: GridView dengan jumlah kolom sesuai lebar.
class ResponsiveGridPage extends StatefulWidget {
  const ResponsiveGridPage({super.key});

  @override
  State<ResponsiveGridPage> createState() => _ResponsiveGridPageState();
}

class _ResponsiveGridPageState extends State<ResponsiveGridPage> {
  late Future<List<Map<String, dynamic>>> coursesFuture;

  @override
  void initState() {
    super.initState();
    coursesFuture = loadCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('P5 Tahap 5 - GridView')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: coursesFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final courses = snapshot.data!;
          return LayoutBuilder(
            builder: (context, constraints) {
              final columns = columnsFor(constraints.maxWidth);
              return Column(
                children: [
                  IdentityHeader(
                    subtitle:
                        'lebar ${constraints.maxWidth.toStringAsFixed(0)} → $columns kolom',
                  ),
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(12),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        mainAxisExtent: 120,
                      ),
                      itemCount: courses.length,
                      itemBuilder: (context, index) =>
                          CourseCard(course: courses[index]),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
