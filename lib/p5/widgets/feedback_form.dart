import 'package:flutter/material.dart';

import '../../identity.dart';

// Tahap 13: Form + TextFormField + GlobalKey<FormState>.
class FeedbackForm extends StatefulWidget {
  const FeedbackForm({super.key});

  @override
  State<FeedbackForm> createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController(text: studentName);
  final nimController = TextEditingController(text: studentId);
  final commentController = TextEditingController();
  String? submitted;

  @override
  void dispose() {
    nameController.dispose();
    nimController.dispose();
    commentController.dispose();
    super.dispose();
  }

  String? _required(String? value, String field) {
    if (value == null || value.trim().isEmpty) return '$field wajib diisi';
    return null;
  }

  void _submit() {
    if (!formKey.currentState!.validate()) return;
    setState(() {
      submitted =
          '${nimController.text.trim()} - ${nameController.text.trim()}: '
          '${commentController.text.trim()}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Nama',
              border: OutlineInputBorder(),
            ),
            validator: (value) => _required(value, 'Nama'),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: nimController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'NIM',
              border: OutlineInputBorder(),
            ),
            validator: (value) => _required(value, 'NIM'),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: commentController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Komentar',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().length < 5) {
                return 'Komentar minimal 5 karakter';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            icon: const Icon(Icons.send),
            label: const Text('Kirim Feedback'),
            onPressed: _submit,
          ),
          if (submitted != null) ...[
            const SizedBox(height: 12),
            Card(
              color: Colors.green.shade50,
              child: ListTile(
                leading: const Icon(Icons.check_circle, color: Colors.green),
                title: const Text('Feedback tersimpan'),
                subtitle: Text(submitted!),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// Halaman demo Tahap 13-14.
class FeedbackPage extends StatelessWidget {
  const FeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('P5 - Form Feedback')),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: FeedbackForm(),
      ),
    );
  }
}
