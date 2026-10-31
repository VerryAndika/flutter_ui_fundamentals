import 'package:flutter/material.dart';

import '../identity.dart';

// Tahap 9: StatefulWidget + TextEditingController + setState().
class GreetingCard extends StatefulWidget {
  const GreetingCard({super.key});

  @override
  State<GreetingCard> createState() => _GreetingCardState();
}

class _GreetingCardState extends State<GreetingCard> {
  final TextEditingController controller = TextEditingController();
  String message = 'Belum ada pesan';

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '$studentId - $studentName',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Tulis pesan',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  message = controller.text.trim().isEmpty
                      ? 'Input masih kosong'
                      : controller.text.trim();
                });
              },
              child: const Text('Tampilkan'),
            ),
            const SizedBox(height: 8),
            Text('Pesan: $message'),
          ],
        ),
      ),
    );
  }
}
