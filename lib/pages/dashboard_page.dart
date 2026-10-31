import 'package:flutter/material.dart';

import '../identity.dart';
import '../services/student_service.dart';
import '../widgets/course_tile.dart';
import '../widgets/identity_card.dart';
import '../widgets/stat_card.dart';
import 'debugging_page.dart';
import 'practice_page.dart';
import 'topics_page.dart';

// Tahap 13 & 14: Learning Dashboard dari JSON statik.
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key, this.dataPath = studentDataPath});

  final String dataPath;

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // Diisi satu kali di initState(), bukan di build().
  late Future<Map<String, dynamic>> studentFuture;

  @override
  void initState() {
    super.initState();
    studentFuture = loadStudentData(widget.dataPath);
  }

  void _reload() {
    setState(() {
      studentFuture = loadStudentData(widget.dataPath);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning Dashboard'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      drawer: _buildDrawer(context),
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>>(
          future: studentFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return _buildError(snapshot.error);
            }

            final data = snapshot.data!;
            final student = data['student'] as Map<String, dynamic>;
            final courses = (data['courses'] as List<dynamic>)
                .cast<Map<String, dynamic>>();

            final int totalCredits = courses.fold(
              0,
              (sum, course) => sum + (course['credits'] as int),
            );
            final int completed = courses
                .where((course) => course['status'] == 'done')
                .length;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                  child: IdentityCard(
                    name: student['name'] as String,
                    nim: student['nim'] as String,
                    motto: student['motto'] as String?,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      buildStatCard(
                        '${courses.length}',
                        'Materi',
                        Icons.menu_book,
                      ),
                      buildStatCard('$totalCredits', 'Total SKS', Icons.school),
                      buildStatCard(
                        '$completed/${courses.length}',
                        'Selesai',
                        Icons.task_alt,
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Daftar Materi',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 12),
                    itemCount: courses.length,
                    itemBuilder: (context, index) =>
                        CourseTile(course: courses[index]),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildError(Object? error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 12),
            Text('Gagal memuat data: $error', textAlign: TextAlign.center),
            const SizedBox(height: 4),
            const Text('$studentId - $studentName'),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _reload, child: const Text('Coba lagi')),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    void open(Widget page) {
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (_) => page));
    }

    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  studentName,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(studentId),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.widgets),
            title: const Text('Latihan Widget (Tahap 4-9)'),
            onTap: () => open(const PracticePage()),
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('Daftar Topik (Tahap 10-11)'),
            onTap: () => open(const TopicsPage()),
          ),
          ListTile(
            leading: const Icon(Icons.bug_report),
            title: const Text('Debugging (Tahap 15)'),
            onTap: () => open(const DebuggingPage()),
          ),
        ],
      ),
    );
  }
}
