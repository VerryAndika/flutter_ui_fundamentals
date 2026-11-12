import 'package:flutter/material.dart';

import '../../config/api_config.dart';
import '../../models/course.dart';
import '../../services/course_api_service.dart';
import '../../widgets/identity_header.dart';

// Tahap 2: GET dari Flutter. Sejak Tahap 4, kode http.get dipindah ke
// CourseApiService; halaman ini hanya memanggil service.
class HttpGetPage extends StatefulWidget {
  const HttpGetPage({super.key});

  @override
  State<HttpGetPage> createState() => _HttpGetPageState();
}

class _HttpGetPageState extends State<HttpGetPage> {
  late Future<List<Course>> future;

  @override
  void initState() {
    super.initState();
    future = CourseApiService(apiBaseUrl).getCourses().then((list) {
      debugPrint('GET $apiUrl -> ${list.length} item');
      return list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('P7 Tahap 2 - HTTP GET')),
      body: FutureBuilder<List<Course>>(
        future: future,
        builder: (context, snapshot) => ListView(
          children: [
            const IdentityHeader(subtitle: 'GET via CourseApiService'),
            ListTile(
              leading: const Icon(Icons.link),
              title: const Text('GET'),
              subtitle: Text(apiUrl),
            ),
            if (snapshot.connectionState != ConnectionState.done)
              const Center(child: CircularProgressIndicator())
            else if (snapshot.hasError)
              ListTile(
                leading: const Icon(Icons.error, color: Colors.red),
                title: const Text('Request gagal'),
                subtitle: Text('${snapshot.error}'),
              )
            else ...[
              ListTile(
                leading: const Icon(Icons.check_circle, color: Colors.green),
                title: Text('Status 200 • ${snapshot.data!.length} item'),
              ),
              for (final item in snapshot.data!.take(5))
                ListTile(
                  dense: true,
                  title: Text(item.title),
                  subtitle: Text('${item.code} • ${item.status}'),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
