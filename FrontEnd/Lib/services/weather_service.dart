
  import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherService {
  final String apiKey = 'd0c8558686d289aa200b6a35ee4a2c28';

  Future<Map<String, dynamic>?> getWeather(double latitude, double longitude) async {
    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&units=metric&appid=$apiKey',
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return null;
  }

  Future<Map<String, dynamic>?> getWeatherByCity(String city) async {
    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?q=$city&units=metric&appid=$apiKey',
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return null;
  }
}

 