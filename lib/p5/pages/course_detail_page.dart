import 'package:flutter/material.dart';

import '../widgets/identity_header.dart';

// Tahap 8: detail course menerima data lewat constructor.
class CourseDetailPage extends StatelessWidget {
  const CourseDetailPage({super.key, required this.course});

  final Map<String, dynamic> course;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(course['code'] as String)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const IdentityHeader(subtitle: 'Detail course'),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course['title'] as String,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  _info(Icons.tag, 'Kode', course['code'] as String),
                  _info(Icons.school, 'SKS', '${course['credits']}'),
                  _info(Icons.flag, 'Status', course['status'] as String),
                  _info(Icons.timelapse, 'Progress', '${course['progress']}%'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _info(IconData icon, String label, String value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(label),
      trailing: Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
