import 'package:flutter/material.dart';

import '../../p5/widgets/identity_header.dart';
import '../../repositories/course_repository.dart';
import '../../services/course_service.dart';
import '../course_provider.dart';

const List<(String, String)> _courses = [
  ('MOB04', 'Navigation & Routing'),
  ('MOB05', 'State Management'),
  ('MOB06', 'REST API & HTTP'),
];

// Tahap 5: widget mendengarkan ChangeNotifier dengan ListenableBuilder.
// State dan method perubahannya berada di CourseProvider, bukan di widget.
class ChangeNotifierPage extends StatefulWidget {
  const ChangeNotifierPage({super.key});

  @override
  State<ChangeNotifierPage> createState() => _ChangeNotifierPageState();
}

class _ChangeNotifierPageState extends State<ChangeNotifierPage> {
  final CourseProvider courseState = CourseProvider(
    CourseRepository(CourseService()),
  );

  @override
  void dispose() {
    courseState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('P6 Tahap 5 - ChangeNotifier')),
      body: ListenableBuilder(
        listenable: courseState,
        builder: (context, _) => ListView(
          children: [
            const IdentityHeader(subtitle: 'notifyListeners()'),
            ListTile(
              leading: const Icon(Icons.favorite, color: Colors.pink),
              title: Text('${courseState.favoriteCount} favorite'),
              subtitle: Text(courseState.favorites.join(', ')),
            ),
            const Divider(),
            for (final (code, title) in _courses)
              ListTile(
                title: Text(title),
                subtitle: Text(code),
                trailing: IconButton(
                  icon: Icon(
                    courseState.isFavorite(code)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: courseState.isFavorite(code) ? Colors.pink : null,
                  ),
                  onPressed: () => courseState.toggleFavorite(code),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
