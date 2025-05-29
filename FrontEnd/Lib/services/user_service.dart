import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  final String baseUrl = 'http://172.20.10.2:8000/api/users';

  /// LOGIN USER
  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Login Success: $data');
        return data;
      } else {
        print('Login Failed: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Login Error: $e');
      return null;
    }
  }

  /// SIGNUP USER (API)
  Future<bool> signupUser(Map<String, dynamic> userData) async {
    try {
      // Add fallback/default values if needed
      final data = {
        'email': userData['email'],
        'password': userData['password'],
        'name': userData['name'] ?? '',
        'phone': userData['phone'] ?? '',
        'region': userData['region'] ?? '',
        'address': userData['address'] ?? '',
      };

      final response = await http.post(
        Uri.parse('$baseUrl/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      final body = jsonDecode(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        print('Signup Success: $body');
        return true;
      } else {
        print('Signup Failed: $body');
        return false;
      }
    } catch (e) {
      print('Signup Error: $e');
      return false;
    }
  }

  /// GET ALL USERS
  Future<List<dynamic>> getUsers() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      print('GetUsers Error: $e');
      rethrow;
    }
  }

  /// GET USER BY ID
  Future<Map<String, dynamic>> getUserById(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('User not found');
      }
    } catch (e) {
      print('GetUserById Error: $e');
      rethrow;
    }
  }

  /// UPDATE USER
  Future<bool> updateUser({
    required String email,
    String? name,
    String? phone,
    String? region,
    String? address,
  }) async {
    final url = Uri.parse("$baseUrl/update");
    final body = jsonEncode({
      "email": email.trim().toLowerCase(),
      "name": name,
      "phone": phone,
      "region": region,
      "address": address,
    });

    print("Sending update request: $body");

    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    print("Update Response (${response.statusCode}): ${response.body}");
    return response.statusCode == 200;
  }

  /// DELETE USER
  Future<bool> deleteUser(String email) async {
    final url = Uri.parse("$baseUrl/${Uri.encodeComponent(email.trim().toLowerCase())}");

    final response = await http.delete(url);

    print("Delete Response (${response.statusCode}): ${response.body}");
    return response.statusCode == 200;
  }
}
