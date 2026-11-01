import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_ui_fundamentals/identity.dart';
import 'package:flutter_ui_fundamentals/p5/responsive_shell.dart';
import 'package:flutter_ui_fundamentals/p5/stages/tahap16_debugging.dart';
import 'package:flutter_ui_fundamentals/p5/widgets/feedback_form.dart';
import 'package:flutter_ui_fundamentals/pages/dashboard_page.dart';
import 'package:flutter_ui_fundamentals/pages/practice_page.dart';
import 'package:flutter_ui_fundamentals/pages/topics_page.dart';

void main() {
  testWidgets('Dashboard memuat identitas dan materi dari JSON', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: DashboardPage()));
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

  testWidgets(
    'Course Explorer: NavigationBar compact, NavigationRail expanded',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      tester.view.physicalSize = const Size(400, 800);
      await tester.pumpWidget(const MaterialApp(home: ResponsiveShell()));
      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.byType(NavigationRail), findsNothing);
      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();
      expect(find.text('Kelas 5 IKI'), findsOneWidget);

      tester.view.physicalSize = const Size(1000, 800);
      await tester.pumpAndSettle();
      expect(find.byType(NavigationRail), findsOneWidget);
      expect(find.byType(NavigationBar), findsNothing);
      // Halaman aktif tetap Profile setelah layout berubah.
      expect(find.text('Kelas 5 IKI'), findsOneWidget);
    },
  );

  testWidgets('Form feedback menolak komentar kurang dari 5 karakter', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: FeedbackPage()));
    await tester.enterText(find.byType(TextFormField).last, 'ok');
    await tester.tap(find.text('Kirim Feedback'));
    await tester.pump();
    expect(find.text('Komentar minimal 5 karakter'), findsOneWidget);
  });

  testWidgets(
    'Kasus B: ListView di Column tanpa Expanded -> unbounded height',
    (tester) async {
      final errors = <FlutterErrorDetails>[];
      final previous = FlutterError.onError;
      FlutterError.onError = errors.add;
      await tester.pumpWidget(
        const MaterialApp(home: UnboundedListPage(fixed: false)),
      );
      FlutterError.onError = previous;
      expect(
        errors.first.exceptionAsString(),
        contains('Vertical viewport was given unbounded height'),
      );

      await tester.pumpWidget(
        const MaterialApp(home: UnboundedListPage(fixed: true)),
      );
      expect(tester.takeException(), isNull);
      expect(find.text('Item 1'), findsOneWidget);
    },
  );
}
