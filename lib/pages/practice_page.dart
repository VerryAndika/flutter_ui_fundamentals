import 'package:flutter/material.dart';

import '../identity.dart';
import '../widgets/greeting_card.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/stat_card.dart';

// Tahap 4-9 dirangkum dalam satu halaman latihan.
class PracticePage extends StatelessWidget {
  const PracticePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Latihan Widget')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _sectionTitle('Tahap 4 - Widget Tree'),
            const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('$studentId - $studentName'),
                SizedBox(height: 12),
                Text('Belajar Widget Tree'),
                SizedBox(height: 12),
                Icon(Icons.widgets, size: 48),
              ],
            ),

            _sectionTitle('Tahap 5 - Text, Icon, Image'),
            const Center(child: ProfileAvatar(radius: 46)),
            const SizedBox(height: 12),
            const Text(
              studentName,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Text(studentId, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            const Text(
              'Saya tertarik membuat aplikasi mobile yang sederhana tapi berguna.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.phone_android),
                SizedBox(width: 8),
                Text('Mobile Programming Student'),
              ],
            ),

            _sectionTitle('Tahap 6 - Row & Column'),
            // Coba ganti spaceEvenly -> spaceBetween / center.
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(children: [Text('8'), Text('Widget')]),
                Column(children: [Text('4'), Text('Layout')]),
                Column(children: [Text('1'), Text('State')]),
              ],
            ),

            _sectionTitle('Tahap 7 - Container, Padding, Card'),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text('$studentId - $studentName'),
                    SizedBox(height: 8),
                    Text('Flutter UI Fundamentals'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.indigo.shade200),
              ),
              child: const Text(
                'Ringkasan: hari ini belajar widget dasar, layout, dan state.',
              ),
            ),

            _sectionTitle('Tahap 8 - Reusable Widget'),
            Row(
              children: [
                buildStatCard('8', 'Widget', Icons.widgets),
                buildStatCard('4', 'Layout', Icons.view_quilt),
                buildStatCard('1', 'State', Icons.sync),
              ],
            ),

            _sectionTitle('Tahap 9 - Input & setState()'),
            const GreetingCard(),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
