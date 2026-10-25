import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherService _weatherService = WeatherService();
  late CityLocation _selectedCity;
  late Future<WeatherData> _weatherFuture;

  @override
  void initState() {
    super.initState();
    _selectedCity = WeatherService.cities.first;
    _loadWeather();
  }

  void _loadWeather() {
    setState(() {
      _weatherFuture = _weatherService.fetchWeather(_selectedCity);
    });
  }

  IconData _getWeatherIcon(int code) {
    if (code == 0) return Icons.wb_sunny;
    if (code <= 3) return Icons.cloud;
    if (code <= 48) return Icons.foggy;
    if (code <= 82) return Icons.umbrella;
    return Icons.thunderstorm;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 8B – Weather Companion'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadWeather,
            tooltip: 'Refresh Weather',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 0,
              color: Colors.blue.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Row(
                  children: [
                    const Icon(Icons.location_city, color: Colors.blue),
                    const SizedBox(width: 12),
                    const Text(
                      'Select City:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<CityLocation>(
                          value: _selectedCity,
                          isExpanded: true,
                          items: WeatherService.cities.map((city) {
                            return DropdownMenuItem(
                              value: city,
                              child: Text(city.name),
                            );
                          }).toList(),
                          onChanged: (newCity) {
                            if (newCity != null) {
                              setState(() {
                                _selectedCity = newCity;
                                _weatherFuture = _weatherService.fetchWeather(_selectedCity);
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<WeatherData>(
                future: _weatherFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 12),
                          Text('Fetching live weather data...'),
                        ],
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, size: 60, color: Colors.red),
                          const SizedBox(height: 12),
                          const Text(
                            'Oops! Something went wrong',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${snapshot.error}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: _loadWeather,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  // TRẠNG THÁI 3: CÓ DỮ LIỆU (SUCCESS STATE)
                  if (!snapshot.hasData) {
                    return const Center(child: Text('No weather data available.'));
                  }

                  final weather = snapshot.data!;

                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              children: [
                                Text(
                                  _selectedCity.name,
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Icon(
                                  _getWeatherIcon(weather.weatherCode),
                                  size: 72,
                                  color: Colors.orangeAccent,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  '${weather.temperature.toStringAsFixed(1)}°C',
                                  style: const TextStyle(
                                    fontSize: 44,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  weather.weatherDescription,
                                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                                ),
                                const Divider(height: 32),
                                // Các thông số phụ: Cảm giác như, Độ ẩm, Tốc độ gió
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    _buildMetricInfo(
                                      Icons.thermostat,
                                      'Feels like',
                                      '${weather.apparentTemperature.toStringAsFixed(1)}°C',
                                    ),
                                    _buildMetricInfo(
                                      Icons.water_drop,
                                      'Humidity',
                                      '${weather.humidity}%',
                                    ),
                                    _buildMetricInfo(
                                      Icons.air,
                                      'Wind',
                                      '${weather.windSpeed} km/h',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        const Text(
                          'Smart Recommendations (What to do today?)',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Card(
                          color: Colors.teal.shade50,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: const Icon(Icons.umbrella, color: Colors.teal, size: 32),
                            title: const Text(
                              'Umbrella Check',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(weather.umbrellaAdvice),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Card(
                          color: Colors.amber.shade50,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: const Icon(Icons.directions_run, color: Colors.orange, size: 32),
                            title: const Text(
                              'Outdoor & Clothing Advice',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(weather.activityAdvice),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricInfo(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.blueGrey),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
      ],
    );
  }
}