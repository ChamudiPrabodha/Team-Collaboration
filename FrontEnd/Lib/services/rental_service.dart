import 'dart:convert';
import 'package:http/http.dart' as http;

class RentalService {
  final String baseUrl = 'http://172.20.10.2:8000/api/rentals'; // replace with your backend URL

  Future<List<dynamic>> getMachines() async {
    final response = await http.get(Uri.parse('$baseUrl/'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load machines');
    }
  }

  Future<String> listMachine(Map<String, dynamic> machineData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/machines'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(machineData),
    );
    if (response.statusCode == 201) {
      return jsonDecode(response.body)['id'];
    } else {
      throw Exception('Failed to list machine');
    }
  }

  Future<Map<String, dynamic>> bookMachine(Map<String, dynamic> bookingData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/book'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(bookingData),
    );
    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to book machine');
    }
  }

  Future<void> makePayment(Map<String, dynamic> paymentData) async {
  final response = await http.post(
    Uri.parse('$baseUrl/payment'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(paymentData),
  );
  if (response.statusCode != 200) {
    throw Exception('Payment failed');
  }
}

  Future<List<dynamic>> getBookingsByEmail(String email) async {
    final response = await http.get(Uri.parse('$baseUrl/bookings/$email'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch bookings');
    }
  }
}
