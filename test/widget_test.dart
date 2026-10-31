import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_ui_fundamentals/identity.dart';
import 'package:flutter_ui_fundamentals/main.dart';
import 'package:flutter_ui_fundamentals/pages/practice_page.dart';
import 'package:flutter_ui_fundamentals/pages/topics_page.dart';

void main() {
  testWidgets('Dashboard memuat identitas dan materi dari JSON', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 200)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Learning Dashboard'), findsOneWidget);
    expect(find.text(studentName), findsOneWidget);
    expect(find.text('Git & GitHub'), findsOneWidget);
    expect(find.text('Flutter UI Fundamentals'), findsOneWidget);
  });

  testWidgets('GreetingCard menampilkan input setelah tombol ditekan', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: PracticePage()));
    await tester.enterText(find.byType(TextField), 'Halo Flutter');
    await tester.ensureVisible(find.text('Tampilkan'));
    await tester.tap(find.text('Tampilkan'));
    await tester.pump();
    expect(find.text('Pesan: Halo Flutter'), findsOneWidget);
  });

  testWidgets('TopicsPage menghitung topik selesai', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: TopicsPage()));
    expect(find.text('2 dari 4 topik selesai'), findsOneWidget);
  });
}
