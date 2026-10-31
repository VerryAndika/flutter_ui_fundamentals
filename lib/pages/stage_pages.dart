import 'package:flutter/material.dart';

import '../identity.dart';
import '../widgets/greeting_card.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/stat_card.dart';

// Arsip tampilan per tahap (1-9) agar hasil tiap tahap tetap bisa
// dibuka ulang lewat route, misalnya /#/tahap4.

// Tahap 1: aplikasi counter bawaan flutter create, title memuat identitas.
class Tahap1Page extends StatefulWidget {
  const Tahap1Page({super.key});

  @override
  State<Tahap1Page> createState() => _Tahap1PageState();
}

class _Tahap1PageState extends State<Tahap1Page> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          '$studentId - $studentName',
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => _counter++),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Tahap 2: MaterialApp + Scaffold minimal.
class Tahap2Page extends StatelessWidget {
  const Tahap2Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter UI Fundamentals')),
      body: const Center(
        child: Text(
          '$studentId\n$studentName',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

// Tahap 4: widget tree dengan Column.
class Tahap4Page extends StatelessWidget {
  const Tahap4Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter UI Fundamentals')),
      body: const Center(
        child: Column(
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
      ),
    );
  }
}

// Tahap 5: Text, Icon, Image.
class Tahap5Page extends StatelessWidget {
  const Tahap5Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Basic Widgets')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ProfileAvatar(radius: 46),
              SizedBox(height: 12),
              Text(
                studentName,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text(studentId),
              SizedBox(height: 8),
              Text(
                'Saya tertarik membuat aplikasi mobile yang sederhana tapi berguna.',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.phone_android),
                  SizedBox(width: 8),
                  Text('Mobile Programming Student'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Tahap 6: Row + Column, tiga variasi MainAxisAlignment.
class Tahap6Page extends StatelessWidget {
  const Tahap6Page({super.key});

  Widget _stats(MainAxisAlignment alignment, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Container(
            color: Colors.indigo.shade50,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: alignment,
              children: const [
                Column(children: [Text('8'), Text('Widget')]),
                Column(children: [Text('4'), Text('Layout')]),
                Column(children: [Text('1'), Text('State')]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Layout Row & Column')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '$studentId - $studentName',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            _stats(MainAxisAlignment.spaceEvenly, 'spaceEvenly'),
            _stats(MainAxisAlignment.spaceBetween, 'spaceBetween'),
            _stats(MainAxisAlignment.center, 'center'),
          ],
        ),
      ),
    );
  }
}

// Tahap 7: Padding, Card, Container + BoxDecoration.
class Tahap7Page extends StatelessWidget {
  const Tahap7Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Spacing & Styling')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    ProfileAvatar(radius: 36),
                    SizedBox(height: 8),
                    Text(
                      '$studentId - $studentName',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('Flutter UI Fundamentals'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
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
          ],
        ),
      ),
    );
  }
}

// Tahap 8: reusable function buildStatCard dipakai tiga kali.
class Tahap8Page extends StatelessWidget {
  const Tahap8Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reusable Widget')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const Text(
              '$studentId - $studentName',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                buildStatCard('8', 'Widget', Icons.widgets),
                buildStatCard('4', 'Layout', Icons.view_quilt),
                buildStatCard('1', 'State', Icons.sync),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Tahap 9: GreetingCard (StatefulWidget + setState).
class Tahap9Page extends StatelessWidget {
  const Tahap9Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Input & State')),
      body: const Padding(padding: EdgeInsets.all(16), child: GreetingCard()),
    );
  }
}
