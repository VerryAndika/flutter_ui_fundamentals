import 'dart:convert';

import 'package:flutter/material.dart';

import '../../models/course.dart';
import '../../widgets/identity_header.dart';
import 'tahap02_http_get.dart';

// Tahap 3: response list -> List<Course>, lalu toJson() untuk request body.
class ModelJsonPage extends StatefulWidget {
  const ModelJsonPage({super.key});

  @override
  State<ModelJsonPage> createState() => _ModelJsonPageState();
}

class _ModelJsonPageState extends State<ModelJsonPage> {
  late Future<List<Course>> future;

  @override
  void initState() {
    super.initState();
    future = fetchCourses().then(
      (list) =>
          list.map((e) => Course.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('P7 Tahap 3 - Model Dart')),
      body: FutureBuilder<List<Course>>(
        future: future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final courses = snapshot.data!;
          return ListView(
            children: [
              const IdentityHeader(subtitle: 'Course.fromJson / toJson'),
              ListTile(
                title: Text('List<Course> berisi ${courses.length} item'),
              ),
              for (final c in courses.take(4))
                ListTile(
                  dense: true,
                  leading: CircleAvatar(child: Text('${c.id}')),
                  title: Text(c.title),
                  subtitle: Text('${c.code} • ${c.credits} SKS • ${c.status}'),
                ),
              const Divider(),
              ListTile(
                title: const Text('toJson() course pertama (body request):'),
                subtitle: Text(jsonEncode(courses.first.toJson())),
              ),
            ],
          );
        },
      ),
    );
  }
}
