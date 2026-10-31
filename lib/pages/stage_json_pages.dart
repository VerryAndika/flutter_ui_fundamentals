import 'dart:convert';

import 'package:flutter/material.dart';

import '../identity.dart';
import '../services/student_service.dart';

// Tahap 12: hasil jsonDecode ditampilkan apa adanya untuk pengecekan.
class Tahap12Page extends StatefulWidget {
  const Tahap12Page({super.key});

  @override
  State<Tahap12Page> createState() => _Tahap12PageState();
}

class _Tahap12PageState extends State<Tahap12Page> {
  late Future<Map<String, dynamic>> studentFuture;

  @override
  void initState() {
    super.initState();
    studentFuture = loadStudentData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('JSON Statik')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: studentFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snapshot.data!;
          debugPrint('student: ${data['student']}');
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '$studentId - $studentName',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text('Jumlah courses: ${(data['courses'] as List).length}'),
                const Divider(),
                Text(
                  const JsonEncoder.withIndent('  ').convert(data),
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Tahap 13: kerangka FutureBuilder dari worksheet.
class Tahap13Page extends StatefulWidget {
  const Tahap13Page({super.key});

  @override
  State<Tahap13Page> createState() => _Tahap13PageState();
}

class _Tahap13PageState extends State<Tahap13Page> {
  late Future<Map<String, dynamic>> studentFuture;

  @override
  void initState() {
    super.initState();
    studentFuture = loadStudentData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Learning Dashboard')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: studentFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Gagal memuat data: ${snapshot.error}'));
          }
          final data = snapshot.data!;
          final student = data['student'] as Map<String, dynamic>;
          final courses = data['courses'] as List<dynamic>;
          return Column(
            children: [
              ListTile(
                leading: const Icon(Icons.person),
                title: Text(student['name'] as String),
                subtitle: Text(student['nim'] as String),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView.builder(
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    final course = courses[index] as Map<String, dynamic>;
                    return ListTile(
                      title: Text(course['title'] as String),
                      subtitle: Text(course['code'] as String),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
