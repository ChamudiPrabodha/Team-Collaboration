import 'dart:convert' show jsonDecode, jsonEncode;

import 'package:http/http.dart' as http;

class CropService {
  final String baseUrl = 'http://172.20.10.2:8000/api/crops'; // Backend URL
  final String authToken;

  CropService(this.authToken);

  Future<List<dynamic>> getCropsByUser() async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load crops');
    }
  }

  Future<bool> addCrop(Map<String, dynamic> cropData) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(cropData),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      print('Add crop failed: ${response.body}');
      return false;
    }
  }

Future<bool> updateGrowthStage(String cropId, String stage) async {
  final url = '$baseUrl/$cropId/growthStage';
  final response = await http.put(
    Uri.parse(url),
    headers: {
      'Authorization': 'Bearer $authToken',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({'growthStage': stage}),
  );
  return response.statusCode == 200;
}

Future<bool> updateProductivity(String cropId, String productivity) async {
  final url = '$baseUrl/$cropId/productivity';
  final response = await http.put(
    Uri.parse(url),
    headers: {
      'Authorization': 'Bearer $authToken',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({'productivity': productivity}),
  );
  return response.statusCode == 200;
}



}
