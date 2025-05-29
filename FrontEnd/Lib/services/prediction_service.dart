import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class PredictionService {
  static const String baseUrl = 'http://172.20.10.2:8000'; // replace with deployed URL if needed

  // For mobile (File)
  static Future<Map<String, dynamic>> predictDisease(File image) async {
    final request = http.MultipartRequest('POST', Uri.parse('$baseUrl/predict'));
    request.files.add(await http.MultipartFile.fromPath('image', image.path));

    final response = await request.send();
    final respStr = await response.stream.bytesToString();
    return jsonDecode(respStr);
  }

  // For web (Uint8List)
  static Future<Map<String, dynamic>> predictDiseaseWeb(Uint8List imageBytes) async {
    final request = http.MultipartRequest('POST', Uri.parse('$baseUrl/predict'));
    request.files.add(
      http.MultipartFile.fromBytes('image', imageBytes, filename: 'image.jpg'),
    );

    final response = await request.send();
    final respStr = await response.stream.bytesToString();
    return jsonDecode(respStr);
  }
}
