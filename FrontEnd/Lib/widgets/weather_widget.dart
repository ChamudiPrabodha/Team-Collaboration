// TODO Implement this library.import 'dart:convert';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class WeatherWidget extends StatefulWidget {
  const WeatherWidget({super.key});

  @override
  _WeatherWidgetState createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  String _status = 'Fetching location...';
  String _weather = '';
  String _temperature = '';
  String _humidity = '';

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    // 1. Check location services
    if (!await Geolocator.isLocationServiceEnabled()) {
      setState(() => _status = 'Location services disabled.');
      return;
    }

    // 2. Request permission
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        setState(() => _status = 'Location permission denied.');
        return;
      }
    }

    // 3. Get position
    final pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() => _status = 'Location: (${pos.latitude}, ${pos.longitude})');

    // 4. Call weather API
    final apiKey = 'YOUR_OPENWEATHERMAP_API_KEY';
    final url =
        'https://api.openweathermap.org/data/2.5/weather?lat=${pos.latitude}&lon=${pos.longitude}&appid=$apiKey&units=metric';

    try {
      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() {
          _weather = data['weather'][0]['main'];
          _temperature = '${data['main']['temp']} °C';
          _humidity = '${data['main']['humidity']}%';
          _status = 'Weather fetched.';
        });
      } else {
        setState(() => _status = 'Failed to fetch weather.');
      }
    } catch (e) {
      setState(() => _status = 'Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_status),
            if (_weather.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('Weather: $_weather'),
              Text('Temperature: $_temperature'),
              Text('Humidity: $_humidity'),
            ],
          ],
        ),
      ),
    );
  }
}
