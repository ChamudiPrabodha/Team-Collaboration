import 'package:flutter/material.dart';
import 'package:govi_arana/services/location_service.dart';
import 'package:govi_arana/services/weather_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final LocationService _locationService = LocationService();
  final WeatherService _weatherService = WeatherService();

  Map<String, dynamic>? _weather;
  final TextEditingController _searchController = TextEditingController();

  GoogleMapController? _mapController;
  LatLng? _currentLatLng;
  Marker? _currentLocationMarker;

  @override
  void initState() {
    super.initState();
    _getLocationAndWeather();
  }

  Future<void> _getLocationAndWeather() async {
    final locationData = await _locationService.getLocation();

    if (locationData != null) {
      final latLng = LatLng(locationData.latitude!, locationData.longitude!);

      final weather = await _weatherService.getWeather(
        locationData.latitude!,
        locationData.longitude!,
      );

      setState(() {
        _currentLatLng = latLng;
        _currentLocationMarker = Marker(
          markerId: const MarkerId('current_location'),
          position: latLng,
          infoWindow: const InfoWindow(title: 'Your Location'),
        );
        _weather = weather;
      });

      if (_mapController != null) {
        _mapController!.animateCamera(CameraUpdate.newLatLngZoom(latLng, 14));
      }
    }
  }

  Future<void> _searchWeather() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    final weather = await _weatherService.getWeatherByCity(query);

    if (weather != null && weather['coord'] != null) {
      final lat = weather['coord']['lat'];
      final lon = weather['coord']['lon'];
      final searchedLatLng = LatLng(lat, lon);

      setState(() {
        _weather = weather;
        _currentLatLng = searchedLatLng;
        _currentLocationMarker = Marker(
          markerId: const MarkerId('searched_location'),
          position: searchedLatLng,
          infoWindow: InfoWindow(title: weather['name']),
        );
      });

      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(searchedLatLng, 14),
        );
      }
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;

    if (_currentLatLng != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(_currentLatLng!, 14),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      appBar: AppBar(
        title: const Text("Weather Info & Location"),
        centerTitle: true,
        backgroundColor: const Color(0xFF2E7D32),
      ),
      body: RefreshIndicator(
        onRefresh: _getLocationAndWeather,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Search Bar
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: "Search city or place",
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (_) => _searchWeather(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _searchWeather,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E7D32),
                    ),
                    child: const Icon(Icons.search),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Google Map container
              SizedBox(
                height: 300,
                child:
                    _currentLatLng == null
                        ? const Center(child: CircularProgressIndicator())
                        : GoogleMap(
                          onMapCreated: _onMapCreated,
                          initialCameraPosition: CameraPosition(
                            target: _currentLatLng!,
                            zoom: 14,
                          ),
                          markers:
                              _currentLocationMarker != null
                                  ? {_currentLocationMarker!}
                                  : {},
                          myLocationEnabled: true,
                          myLocationButtonEnabled: true,
                        ),
              ),

              const SizedBox(height: 20),

              if (_weather != null)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    children: [
                      Image.network(
                        'https://openweathermap.org/img/wn/${_weather!['weather'][0]['icon']}@2x.png',
                        width: 64,
                        height: 64,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${_weather!['main']['temp']}°C',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              '${_weather!['weather'][0]['description']}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        _weather!['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                )
              else
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
