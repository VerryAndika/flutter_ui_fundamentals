import 'package:flutter/material.dart';

import '../../identity.dart';

// Tahap 13: Form + TextFormField + GlobalKey<FormState>.
// Tahap 14: AlertDialog, loading, dan SnackBar.
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
  bool sending = false;

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

  // Tahap 14: konfirmasi (Dialog) -> loading -> SnackBar.
  Future<void> _submit() async {
    if (sending || !formKey.currentState!.validate()) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Kirim feedback ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Kirim'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => sending = true);
    await Future<void>.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    setState(() {
      sending = false;
      submitted =
          '${nimController.text.trim()} - ${nameController.text.trim()}: '
          '${commentController.text.trim()}';
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Data berhasil disimpan')));
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
            icon: sending
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.send),
            label: Text(sending ? 'Mengirim...' : 'Kirim Feedback'),
            // Tombol nonaktif selama proses agar tidak terkirim dua kali.
            onPressed: sending ? null : _submit,
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
