// services/disease_service.dart

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

const String baseUrl = 'http://172.20.10.2:8000/api/diseases';

class DiseaseService {
  Future<List<dynamic>> fetchAllDiseases() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load diseases');
    }
  }

  Future<Map<String, dynamic>> fetchDiseaseById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Disease not found');
    }
  }

  Future<void> createDisease(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create disease');
    }
  }

  Future<void> addRemedy(String id, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$id/remedy'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to add remedy');
    }
  }

  static predictDisease(File file) {}
}
