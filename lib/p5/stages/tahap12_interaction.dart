import 'package:flutter/material.dart';

import '../widgets/course_card.dart';
import '../widgets/identity_header.dart';

const Map<String, dynamic> _sampleCourse = {
  'code': 'MOB05',
  'title': 'State Management',
  'credits': 3,
  'status': 'planned',
  'progress': 0,
};

// Tahap 12: button, InkWell, dan GestureDetector.
class InteractionPage extends StatefulWidget {
  const InteractionPage({super.key});

  @override
  State<InteractionPage> createState() => _InteractionPageState();
}

class _InteractionPageState extends State<InteractionPage> {
  bool isFavorite = false;
  int tapCount = 0;
  String lastAction = 'Belum ada aksi';

  void _showInfo() {
    setState(() => lastAction = 'Long press pada card');
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _sampleCourse['title'] as String,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text('Info cepat dari long press: 3 SKS, status rencana.'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('P5 Tahap 12 - Interaction')),
      body: ListView(
        children: [
          const IdentityHeader(subtitle: 'Interaction'),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('InkWell: tap / long press card (ada ripple)'),
                CourseCard(
                  course: _sampleCourse,
                  favorite: isFavorite,
                  onTap: () => setState(() {
                    tapCount++;
                    lastAction = 'Tap card ($tapCount x)';
                  }),
                  onLongPress: _showInfo,
                  onFavoriteChanged: (value) => setState(() {
                    isFavorite = value;
                    lastAction = value ? 'Favorite aktif' : 'Favorite nonaktif';
                  }),
                ),
                const SizedBox(height: 16),
                const Text('GestureDetector: double tap (tanpa ripple)'),
                const SizedBox(height: 8),
                GestureDetector(
                  onDoubleTap: () =>
                      setState(() => lastAction = 'Double tap pada kotak'),
                  child: Container(
                    height: 72,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.indigo.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text('Double tap di sini'),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  color: Colors.amber.shade50,
                  child: ListTile(
                    leading: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.pink : null,
                    ),
                    title: Text('Aksi terakhir: $lastAction'),
                    subtitle: Text('Favorite: $isFavorite • tap: $tapCount'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
