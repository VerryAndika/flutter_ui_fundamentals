import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../config/api_config.dart';
import '../../widgets/identity_header.dart';

// Tahap 2: GET langsung dari halaman (sementara; dipindah ke service
// pada Tahap 4). Status code diperiksa sebelum body diproses.
Future<List<dynamic>> fetchCourses() async {
  final response = await http.get(Uri.parse(apiUrl));

  if (response.statusCode == 200) {
    return jsonDecode(response.body) as List<dynamic>;
  }

  throw Exception('HTTP ${response.statusCode}');
}

class HttpGetPage extends StatefulWidget {
  const HttpGetPage({super.key});

  @override
  State<HttpGetPage> createState() => _HttpGetPageState();
}

class _HttpGetPageState extends State<HttpGetPage> {
  late Future<List<dynamic>> future;

  @override
  void initState() {
    super.initState();
    future = fetchCourses().then((list) {
      debugPrint('GET $apiUrl -> ${list.length} item');
      return list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('P7 Tahap 2 - HTTP GET')),
      body: FutureBuilder<List<dynamic>>(
        future: future,
        builder: (context, snapshot) => ListView(
          children: [
            const IdentityHeader(subtitle: 'http.get'),
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
                  title: Text('${item['title']}'),
                  subtitle: Text('${item['code']} • ${item['status']}'),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
