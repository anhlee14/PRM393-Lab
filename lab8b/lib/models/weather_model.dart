class WeatherData {
  final double temperature;
  // Feel like
  final double apparentTemperature;
  final int humidity;
  final double windSpeed;
  final int weatherCode;

  const WeatherData({
    required this.temperature,
    required this.apparentTemperature,
    required this.humidity,
    required this.windSpeed,
    required this.weatherCode,
  });

  // Chuyển đổi JSON
  factory WeatherData.fromJson(Map<String, dynamic> json) {
    final current = json['current'] as Map<String, dynamic>;
    return WeatherData(
      temperature: (current['temperature_2m'] as num).toDouble(),
      apparentTemperature: (current['apparent_temperature'] as num).toDouble(),
      humidity: (current['relative_humidity_2m'] as num).toInt(),
      windSpeed: (current['wind_speed_10m'] as num).toDouble(),
      weatherCode: (current['weather_code'] as num).toInt(),
    );
  }

  // Dịch mã thời tiết
  String get weatherDescription {
    if (weatherCode == 0) return 'Clear sky';
    if (weatherCode <= 3) return 'Partly cloudy';
    if (weatherCode <= 48) return 'Foggy';
    if (weatherCode <= 67) return 'Rainy';
    if (weatherCode <= 77) return 'Snowy';
    if (weatherCode <= 82) return 'Rain showers';
    return 'Thunderstorm (Giông bão)';
  }

  String get umbrellaAdvice {
    if (weatherCode >= 51) {
      return 'Take an umbrella! Rain is expected today.';
    }
    return 'No umbrella needed. The sky looks dry!';
  }

  String get activityAdvice {
    if (weatherCode >= 51) {
      return 'Better for indoor activities (movies, reading, coding).';
    }
    if (temperature > 33) {
      return 'Too hot for outdoor sports! Stay hydrated and wear light clothes.';
    }
    if (temperature < 18) {
      return 'Quite chilly! Wear a warm jacket if you go outside.';
    }
    return 'Nice weather for a walk or outdoor sports!';
  }
}