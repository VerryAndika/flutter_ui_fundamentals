import 'package:flutter/material.dart';

import '../widgets/identity_header.dart';

// Destinasi Home pada Course Explorer.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        IdentityHeader(subtitle: 'Home'),
        Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Selamat datang di Course Explorer. Buka tab Courses untuk '
            'melihat daftar course dan Profile untuk mengirim feedback.',
          ),
        ),
      ],
    );
  }
}
