class WeatherModel {
  final String name;
  final WeatherInfo main;
  final List<Weather> weather;

  WeatherModel({
    required this.name,
    required this.main,
    required this.weather,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      name: json['name'],
      main: WeatherInfo.fromJson(json['main']),
      weather: (json['weather'] as List)
          .map((w) => Weather.fromJson(w))
          .toList(),
    );
  }
}

class WeatherInfo {
  final double temp;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int humidity;

  WeatherInfo({
    required this.temp,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.humidity,
  });

  factory WeatherInfo.fromJson(Map<String, dynamic> json) {
    return WeatherInfo(
      temp: json['temp'].toDouble(),
      feelsLike: json['feels_like'].toDouble(),
      tempMin: json['temp_min'].toDouble(),
      tempMax: json['temp_max'].toDouble(),
      humidity: json['humidity'],
    );
  }
}

class Weather {
  final String main;
  final String description;
  final String icon;

  Weather({
    required this.main,
    required this.description,
    required this.icon,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      main: json['main'],
      description: json['description'],
      icon: json['icon'],
    );
  }

  String get animationPath {
    switch (main.toLowerCase()) {
      case 'clear':
        return 'assets/images/sunny.json';
      case 'clouds':
        return 'assets/images/cloudy.json';
      case 'rain':
        return 'assets/images/rainy.json';
      case 'snow':
        return 'assets/images/snowy.json';
      case 'thunderstorm':
        return 'assets/images/thunder.json';
      default:
        return 'assets/images/sunny.json';
    }
  }
}