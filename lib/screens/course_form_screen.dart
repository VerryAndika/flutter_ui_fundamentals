import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';
import '../widgets/identity_header.dart';

// P7 Tahap 6: form Create Course. Data dikirim lewat provider ->
// repository -> service; screen tidak memanggil package http.
class CourseFormScreen extends StatefulWidget {
  const CourseFormScreen({super.key});

  @override
  State<CourseFormScreen> createState() => _CourseFormScreenState();
}

class _CourseFormScreenState extends State<CourseFormScreen> {
  final formKey = GlobalKey<FormState>();
  final codeController = TextEditingController();
  final titleController = TextEditingController();
  final creditsController = TextEditingController();
  String status = 'planned';

  static const statuses = ['planned', 'active', 'done'];

  @override
  void dispose() {
    codeController.dispose();
    titleController.dispose();
    creditsController.dispose();
    super.dispose();
  }

  String? _required(String? v, String field) =>
      (v == null || v.trim().isEmpty) ? '$field wajib diisi' : null;

  Future<void> _submit() async {
    final provider = context.read<CourseProvider>();
    if (provider.isSaving || !formKey.currentState!.validate()) return;
    final course = Course(
      code: codeController.text.trim(),
      title: titleController.text.trim(),
      credits: int.parse(creditsController.text.trim()),
      status: status,
    );
    final messenger = ScaffoldMessenger.of(context);
    try {
      final created = await provider.createCourse(course);
      // Setelah await: pastikan halaman masih ada (State.mounted =
      // context.mounted milik State ini) sebelum memakai Navigator.
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text('Course ${created.code} berhasil dibuat')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
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
    final saving = context.watch<CourseProvider>().isSaving;
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Course')),
      body: Form(
        key: formKey,
        child: ListView(
          children: [
            const IdentityHeader(subtitle: 'Form Create Course'),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: codeController,
                    decoration: const InputDecoration(
                      labelText: 'Code',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => _required(v, 'Code'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => _required(v, 'Title'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: creditsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Credits (SKS)',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) {
                      final empty = _required(v, 'Credits');
                      if (empty != null) return empty;
                      final n = int.tryParse(v!.trim());
                      if (n == null || n <= 0) return 'Credits harus angka > 0';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: status,
                    decoration: const InputDecoration(
                      labelText: 'Status',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      for (final s in statuses)
                        DropdownMenuItem(value: s, child: Text(s)),
                    ],
                    onChanged: (v) => setState(() => status = v!),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    icon: saving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save),
                    label: Text(saving ? 'Menyimpan...' : 'Simpan'),
                    onPressed: saving ? null : _submit,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
