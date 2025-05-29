import 'dart:convert';
import 'package:http/http.dart' as http;

const String baseUrl = 'http://172.20.10.2:8000/api/guides';

Future<List<Map<String, dynamic>>> fetchGuides() async {
  final response = await http.get(Uri.parse(baseUrl));
  if (response.statusCode == 200) {
    final List data = jsonDecode(response.body);
    return data.cast<Map<String, dynamic>>();
  } else {
    throw Exception('Failed to load guides');
  }
}

Future<Map<String, dynamic>> fetchGuideById(String id) async {
  final response = await http.get(Uri.parse('$baseUrl/$id'));
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Guide not found');
  }
}

Future<void> addGuide(Map<String, dynamic> guide) async {
  final response = await http.post(
    Uri.parse(baseUrl),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(guide),
  );
  if (response.statusCode != 201) {
    throw Exception('Failed to add guide');
  }
}

Future<void> updateGuide(String id, Map<String, dynamic> guide) async {
  final response = await http.put(
    Uri.parse('$baseUrl/$id'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(guide),
  );
  if (response.statusCode != 200) {
    throw Exception('Failed to update guide');
  }
}

Future<void> deleteGuide(String id) async {
  final response = await http.delete(Uri.parse('$baseUrl/$id'));
  if (response.statusCode != 200) {
    throw Exception('Failed to delete guide');
  }
}
