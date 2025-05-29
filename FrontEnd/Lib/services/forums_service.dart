import 'dart:convert';
import 'package:http/http.dart' as http;

class ForumService {
  static const String _host = '172.20.10.2:8000';
  static const String _path = '/api/forums';
  static final Duration _timeout = Duration(seconds: 10);

  static Uri _buildUri([String? pathSuffix]) {

    return Uri.http(_host, pathSuffix != null ? '$_path/$pathSuffix' : _path);
  }

  // 1. Get all forum posts
  static Future<List<Map<String, dynamic>>> getAllForums() async {
    final response = await http.get(_buildUri()).timeout(_timeout);

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => e as Map<String, dynamic>).toList();
    } else {
      throw Exception("Failed to load forums: ${response.statusCode}");
    }
  }

  // 2. Get forum by ID
  static Future<Map<String, dynamic>?> getForumById(String forumId) async {
    final response = await http.get(_buildUri(forumId)).timeout(_timeout);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('Error fetching forum: ${response.statusCode}');
      return null;
    }
  }

  // 3. Create new forum post
  static Future<String> createForum({
    required String title,
    required String content,
    required Map<String, String> author,
  }) async {
    final response = await http
        .post(
          _buildUri(),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'title': title,
            'content': content,
            'author': author,
          }),
        )
        .timeout(_timeout);

    if (response.statusCode == 201) {
      return "Forum post created successfully";
    } else {
      throw Exception("Failed to create forum post: ${response.body}");
    }
  }

  // 4. Add reply to forum post
  static Future<String> addReply({
    required String forumId,
    required String reply,
    required Map<String, dynamic> replier,
  }) async {
    final response = await http
        .post(
          _buildUri('$forumId/reply'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'reply': reply,
            'replier': replier,
          }),
        )
        .timeout(_timeout);

    if (response.statusCode == 200) {
      return "Reply added successfully";
    } else {
      throw Exception("Failed to post reply: ${response.body}");
    }
  }
}
