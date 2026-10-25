import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class CityLocation {
  final String name;
  final double lat;
  final double lon;

  const CityLocation(this.name, this.lat, this.lon);
}

class WeatherService {
  // Danh sách các thành phố
  static const List<CityLocation> cities = [
    CityLocation('Hanoi', 21.0285, 105.8542),
    CityLocation('Da Nang', 16.0544, 108.2022),
    CityLocation('Ho Chi Minh City', 10.8231, 106.6297),
    CityLocation('Tokyo', 35.6762, 139.6503),
    CityLocation('London', 51.5074, -0.1278),
  ];

  Future<WeatherData> fetchWeather(CityLocation city) async {
    // await Future.delayed(const Duration(seconds: 3));
    // throw Exception('Failed to connect to weather server. Please check your internet.');

    final url = Uri.parse(
      'https://api.open-meteo.com/v1/forecast'
          '?latitude=${city.lat}&longitude=${city.lon}'
          '&current=temperature_2m,relative_humidity_2m,apparent_temperature,weather_code,wind_speed_10m',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return WeatherData.fromJson(data);
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: Unable to fetch weather data ($e)');
    }
  }
}