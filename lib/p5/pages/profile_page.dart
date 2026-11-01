import 'package:flutter/material.dart';

import '../../identity.dart';

// Destinasi Profile pada Course Explorer.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        Center(child: CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40))),
        SizedBox(height: 12),
        Text(
          studentName,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(studentId, textAlign: TextAlign.center),
        Text('Kelas 5 IKI', textAlign: TextAlign.center),
      ],
    );
  }
}
