import 'package:flutter/material.dart';

import '../../identity.dart';
import '../stages/tahap04_flexible_wrap.dart';
import '../widgets/feedback_form.dart';

// Destinasi Profile pada Course Explorer: identitas, skill, dan feedback.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // ListView agar tetap bisa di-scroll saat keyboard terbuka.
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Center(
          child: CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
        ),
        const SizedBox(height: 12),
        const Text(
          studentName,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const Text(studentId, textAlign: TextAlign.center),
        const Text('Kelas 5 IKI', textAlign: TextAlign.center),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: skills.map((e) => Chip(label: Text(e))).toList(),
        ),
        const SizedBox(height: 24),
        const Text(
          'Feedback',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        const FeedbackForm(),
      ],
    );
  }
}
